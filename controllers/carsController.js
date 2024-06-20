const carsService = require('./../services/carsService');

// Fonction pour obtenir toutes les voitures du parc avec leurs rendez-vous à venir et ventes pour les voitures vendues
exports.getAllCars = async (req, res) => {
    // const { statut } = req.query;
    const statut  = "disponible";

    try {
        const results = await carsService.getAllCars(statut);
        res.json(results);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour obtenir les détails d'une voiture spécifique en fonction de son identifiant
exports.getCarById = async (req, res) => {
    try {
        const results = await carsService.getCarById(req.params.id);
        if (results.length === 0) {
            return res.status(404).json({ message: 'Voiture non trouvée' });
        }
        res.json(results[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour déclarer un arrivage de voitures
exports.declareArrival = async (req, res) => {
    try {
        const results = await carsService.declareArrival(req.body);
        res.json({ message: 'Arrivage déclaré avec succès', newCar: results });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour déclarer une vente de voiture
exports.declareSale = async (req, res) => {
    try {
        const results = await carsService.declareSale(req.body);
        res.json({ message: 'Vente déclarée avec succès', newSale: results });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour obtenir toutes les places disponibles
exports.getAvailablePlaces = async (req, res) => {
    try {
        const results = await carsService.getAvailablePlaces();
        res.json(results);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Fonction pour prendre rendez-vous pour la réparation d'une voiture
exports.bookAppointment = async (req, res) => {
    console.log("toto");
    try {
        const results = await carsService.bookAppointment(req.body);
        res.json({ message: 'Rendez-vous pris avec succès', newAppointment: results });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
