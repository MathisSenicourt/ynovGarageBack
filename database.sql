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
                          statut ENUM('disponible', 'reserve', 'vendu') NOT NULL,
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
