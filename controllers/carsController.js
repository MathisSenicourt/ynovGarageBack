const db = require('services/db');

// Fonction pour obtenir toutes les voitures du parc avec leurs rendez-vous à venir et ventes pour les voitures vendues
exports.getAllCars = async (req, res) => {
    const { statut } = req.query;

    let query = `
        SELECT v.id, v.marque, v.modele, v.annee, v.prix, v.kilometrage, v.statut, v.emplacement_id,
               rv.id AS rendez_vous_id, rv.date AS rendez_vous_date, rv.type AS rendez_vous_type, rv.statut AS rendez_vous_statut,
               s.id AS vente_id, s.date AS vente_date, s.client_id AS vente_client_id, s.commercial_id AS vente_commercial_id
        FROM voitures v
        LEFT JOIN rendez_vous rv ON v.id = rv.voiture_id AND rv.date > NOW() AND rv.statut != 'annule'
        LEFT JOIN ventes s ON v.id = s.voiture_id
    `;

    let params = [];

    if (statut) {
        const statuts = statut.split(',');
        const placeholders = statuts.map(() => '?').join(',');
        query += ` WHERE v.statut IN (${placeholders})`;
        params = statuts;
    }

    try {
        await db.query(query, params, (error, results) => {
            if (error) {
                return res.status(500).json({message: error.message});
            }
            res.json(results);
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


// Fonction pour obtenir les détails d'une voiture spécifique en fonction de son identifiant
exports.getCarById = async (req, res) => {
    try {
        const car = await db.query('SELECT * FROM voitures WHERE id = ?', [req.params.id]);
        if (car.length === 0) {
            return res.status(404).json({ message: 'Voiture non trouvée' });
        }
        res.json(car[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour déclarer un arrivage de voitures
exports.declareArrival = async (req, res) => {
    const { marque, modele, annee, prix, kilometrage, statut, emplacement_id } = req.body;
    try {
        const newCar = await db.query('INSERT INTO voitures (marque, modele, annee, prix, kilometrage, statut, emplacement_id) VALUES (?, ?, ?, ?, ?, ?, ?)', [marque, modele, annee, prix, kilometrage, statut, emplacement_id]);
        res.json({ message: 'Arrivage déclaré avec succès', newCar });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour déclarer une vente de voiture
exports.declareSale = async (req, res) => {
    const { voiture_id, commercial_id, client_id, date } = req.body;
    try {
        const newSale = await db.query('INSERT INTO ventes (voiture_id, commercial_id, client_id, date) VALUES (?, ?, ?, ?)', [voiture_id, commercial_id, client_id, date]);
        res.json({ message: 'Vente déclarée avec succès', newSale });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour prendre rendez-vous pour la réparation d'une voiture
exports.bookAppointment = async (req, res) => {
    const { voiture_id, client_id, date, type } = req.body;
    try {
        const newAppointment = await db.query('INSERT INTO rendez_vous (voiture_id, client_id, date, type) VALUES (?, ?, ?, ?)', [voiture_id, client_id, date, type]);
        res.json({ message: 'Rendez-vous pris avec succès', newAppointment });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
