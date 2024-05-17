const express = require('express');
const router = express.Router();
const carsController = require('../controllers/carsController');

// Route pour obtenir toutes les voitures, avec possibilité de filtrer par statut
router.get('/', carsController.getAllCars);

// Route pour obtenir les détails d'une voiture spécifique
router.get('/:id', carsController.getCarById);

// Route pour déclarer un arrivage d'une ou plusieurs voitures
router.post('/arrival', carsController.declareArrival);

// Route pour déclarer une vente de voiture
router.post('/sale', carsController.declareSale);

// Route pour prendre rendez-vous pour la réparation d'une voiture
router.post('/appointment', carsController.bookAppointment);

module.exports = router;
