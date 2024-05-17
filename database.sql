-- Créer la base de données
CREATE DATABASE IF NOT EXISTS ynovGarage;

-- Se connecter à la base de données
USE ynovGarage;

-- Supprimer les tables si elles existent déjà
DROP TABLE IF EXISTS rendez_vous;
DROP TABLE IF EXISTS ventes;
DROP TABLE IF EXISTS ateliers;
DROP TABLE IF EXISTS voitures;
DROP TABLE IF EXISTS emplacements;
DROP TABLE IF EXISTS utilisateurs;

-- Créer les tables nécessaires

-- Table des utilisateurs
CREATE TABLE utilisateurs (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              nom VARCHAR(100) NOT NULL,
                              prenom VARCHAR(100) NOT NULL,
                              email VARCHAR(100) UNIQUE NOT NULL,
                              mot_de_passe VARCHAR(255) NOT NULL,
                              role ENUM('gestionnaire', 'commercial', 'garagiste', 'client') NOT NULL,
                              code_matricule VARCHAR(50)
);

-- Table des emplacements
CREATE TABLE emplacements (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              numero VARCHAR(50) UNIQUE NOT NULL,
                              zone ENUM('concessionnaire', 'atelier') NOT NULL
);

-- Table des voitures
CREATE TABLE voitures (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          marque VARCHAR(100) NOT NULL,
                          modele VARCHAR(100) NOT NULL,
                          annee INT CHECK (annee > 1900) NOT NULL,
                          prix DECIMAL(10, 2) NOT NULL,
                          kilometrage INT NOT NULL,
                          statut ENUM('disponible', 'attente reservation', 'reserve', 'vendu') NOT NULL,
                          emplacement_id INT,
                          CONSTRAINT fk_emplacement FOREIGN KEY (emplacement_id) REFERENCES emplacements(id)
);

-- Table des rendez_vous
CREATE TABLE rendez_vous (
                             id INT AUTO_INCREMENT PRIMARY KEY,
                             voiture_id INT NOT NULL,
                             client_id INT NOT NULL,
                             date TIMESTAMP NOT NULL,
                             type ENUM('reparation', 'essai') NOT NULL,
                             statut ENUM('en attente', 'confirme', 'annule') NOT NULL,
                             CONSTRAINT fk_voiture FOREIGN KEY (voiture_id) REFERENCES voitures(id),
                             CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES utilisateurs(id)
);

-- Table des ventes
CREATE TABLE ventes (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        voiture_id INT NOT NULL,
                        commercial_id INT NOT NULL,
                        client_id INT NOT NULL,
                        date TIMESTAMP NOT NULL,
                        CONSTRAINT fk_voiture_vente FOREIGN KEY (voiture_id) REFERENCES voitures(id),
                        CONSTRAINT fk_commercial FOREIGN KEY (commercial_id) REFERENCES utilisateurs(id),
                        CONSTRAINT fk_client_vente FOREIGN KEY (client_id) REFERENCES utilisateurs(id)
);

-- Table des ateliers
CREATE TABLE ateliers (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          voiture_id INT NOT NULL,
                          proprietaire_id INT NOT NULL,
                          garagiste_id INT NOT NULL,
                          descriptif TEXT,
                          emplacement_id INT NOT NULL,
                          CONSTRAINT fk_voiture_atelier FOREIGN KEY (voiture_id) REFERENCES voitures(id),
                          CONSTRAINT fk_proprietaire FOREIGN KEY (proprietaire_id) REFERENCES utilisateurs(id),
                          CONSTRAINT fk_garagiste FOREIGN KEY (garagiste_id) REFERENCES utilisateurs(id),
                          CONSTRAINT fk_emplacement_atelier FOREIGN KEY (emplacement_id) REFERENCES emplacements(id)
);

-- Ajouter 20 emplacements de concessionnaire
INSERT INTO emplacements (numero, zone) VALUES
                                            ('none', 'concessionnaire'),
                                            ('Conc001', 'concessionnaire'),
                                            ('Conc002', 'concessionnaire'),
                                            ('Conc003', 'concessionnaire'),
                                            ('Conc004', 'concessionnaire'),
                                            ('Conc005', 'concessionnaire'),
                                            ('Conc006', 'concessionnaire'),
                                            ('Conc007', 'concessionnaire'),
                                            ('Conc008', 'concessionnaire'),
                                            ('Conc009', 'concessionnaire'),
                                            ('Conc010', 'concessionnaire'),
                                            ('Conc011', 'concessionnaire'),
                                            ('Conc012', 'concessionnaire'),
                                            ('Conc013', 'concessionnaire'),
                                            ('Conc014', 'concessionnaire'),
                                            ('Conc015', 'concessionnaire'),
                                            ('Conc016', 'concessionnaire'),
                                            ('Conc017', 'concessionnaire'),
                                            ('Conc018', 'concessionnaire'),
                                            ('Conc019', 'concessionnaire'),
                                            ('Conc020', 'concessionnaire');

-- Ajouter 5 emplacements d'atelier
INSERT INTO emplacements (numero, zone) VALUES
                                            ('Atelier001', 'atelier'),
                                            ('Atelier002', 'atelier'),
                                            ('Atelier003', 'atelier'),
                                            ('Atelier004', 'atelier'),
                                            ('Atelier005', 'atelier');

-- Ajout de voitures fictives dans la table 'voitures'
INSERT INTO voitures (marque, modele, annee, prix, kilometrage, statut, emplacement_id)
VALUES
    ('Toyota', 'Corolla', 2020, 20000.00, 15000, 'disponible', 1),
    ('Ford', 'Mustang', 2018, 30000.00, 30000, 'disponible', 2),
    ('Honda', 'Civic', 2021, 25000.00, 10000, 'disponible', 3),
    ('Chevrolet', 'Camaro', 2019, 35000.00, 25000, 'disponible', 4),
    ('BMW', '3 Series', 2022, 45000.00, 5000, 'disponible', 5),
    ('Mercedes', 'C-Class', 2020, 40000.00, 20000, 'disponible', 6),
    ('Audi', 'A4', 2019, 38000.00, 22000, 'disponible', 7),
    ('Tesla', 'Model 3', 2021, 50000.00, 12000, 'disponible', 8),
    ('Nissan', 'Altima', 2018, 18000.00, 35000, 'disponible', 9),
    ('Hyundai', 'Elantra', 2020, 19000.00, 17000, 'disponible', 10),
    ('Volkswagen', 'Golf', 2021, 23000.00, 15000, 'disponible', 11),
    ('Kia', 'Optima', 2019, 21000.00, 27000, 'disponible', 12),
    ('Subaru', 'Impreza', 2022, 24000.00, 8000, 'disponible', 13),
    ('Mazda', 'Mazda3', 2020, 22000.00, 19000, 'disponible', 14),
    ('Dodge', 'Charger', 2018, 29000.00, 32000, 'disponible', 15),
    ('Jeep', 'Wrangler', 2021, 40000.00, 10000, 'disponible', 16),
    ('Lexus', 'IS', 2020, 42000.00, 14000, 'disponible', 17),
    ('Infiniti', 'Q50', 2019, 37000.00, 25000, 'disponible', 18),
    ('Acura', 'TLX', 2021, 43000.00, 9000, 'disponible', 19),
    ('Cadillac', 'ATS', 2018, 35000.00, 28000, 'disponible', 20);

