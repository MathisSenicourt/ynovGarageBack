const db = require('./db');

// Fonction pour obtenir toutes les voitures du parc avec leurs rendez-vous à venir et ventes pour les voitures vendues
exports.getAllCars = async (statut) => {
    let query = `
        SELECT v.id,
               v.marque,
               v.modele,
               v.annee,
               v.prix,
               v.kilometrage,
               v.statut,
               v.emplacement_id,
               rv.id           AS rendez_vous_id,
               rv.date         AS rendez_vous_date,
               rv.type         AS rendez_vous_type,
               rv.statut       AS rendez_vous_statut,
               s.id            AS vente_id,
               s.date          AS vente_date,
               s.client_id     AS vente_client_id,
               s.commercial_id AS vente_commercial_id
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

    return await db.query(query, params);
};

// Fonction pour obtenir les détails d'une voiture spécifique en fonction de son identifiant
exports.getCarById = async (id) => {
    return await db.query('SELECT * FROM voitures WHERE id = ?', [id]);
};

// Fonction pour déclarer un arrivage de voitures
exports.declareArrival = async (car) => {
    const {marque, modele, annee, prix, kilometrage, statut, emplacement_id} = car;
    return await db.query('INSERT INTO voitures (marque, modele, annee, prix, kilometrage, statut, emplacement_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [marque, modele, annee, prix, kilometrage, statut, emplacement_id]);
};

// Fonction pour déclarer une vente de voiture
exports.declareSale = async (sale) => {
    const {voiture_id, commercial_id, client_id, date} = sale;
    return await db.query('INSERT INTO ventes (voiture_id, commercial_id, client_id, date) VALUES (?, ?, ?, ?)',
        [voiture_id, 1, 1, date]);
};

// Fonction pour obtenir toutes les places disponibles
exports.getAvailablePlaces = async () => {
    const query = `
        SELECT e.id, e.numero, e.zone
        FROM emplacements e
                 LEFT JOIN voitures v ON e.id = v.emplacement_id
        WHERE v.id IS NULL AND e.id != 1
    `;

    return await db.query(query);
};

// Fonction pour prendre rendez-vous pour la réparation d'une voiture
exports.bookAppointment = async (appointment) => {
    const {voiture_id, client_id, date, type} = appointment;
    return await db.query('INSERT INTO rendez_vous (voiture_id, client_id, date, type) VALUES (?, ?, ?, ?)',
        [voiture_id, 1, date, type]);
};
