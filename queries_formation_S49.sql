CREATE DATABASE formation;

SHOW DATABASES;

USE formation;

SHOW TABLES;

CREATE TABLE contact (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    phone_number VARCHAR(10) NOT NULL
);

DROP TABLE contact;

SHOW TABLES;
DESCRIBE contact;


INSERT INTO contact (phone_number, lastname, firstname)
VALUES ('0615561135', 'Aldaitz', 'Thomas');

INSERT INTO contact (phone_number, lastname, firstname)
VALUES ('0615561138', 'Test', 'Robert'),
	  ('0625616161', 'Test', 'Jean-Jacques')
;


SELECT lastname AS Nom, firstname AS Prénom, LENGTH(firstname) AS longueurPrénom
FROM contact
ORDER BY longueurPrénom DESC
LIMIT 5, 15
;


SELECT COUNT(id)
FROM contact
WHERE firstname LIKE 'T%';

DROP TABLE animal;
DROP TABLE espece;
DROP TABLE enclos;
DROP TABLE secteur;

CREATE TABLE animal (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nom VARCHAR(100) NOT NULL,
	date_de_naissance DATE,
	poids INTEGER,
	taille FLOAT,
	espece_id INT,
	enclos_id INT
);

CREATE TABLE espece (
	id INTEGER PRIMARY KEY AUTO_INCREMENT  ,
	nom VARCHAR(100) NOT NULL,
	est_dangeureux BOOLEAN,
	est_sensible BOOLEAN
);

CREATE TABLE enclos (
	id INTEGER PRIMARY KEY AUTO_INCREMENT  ,
	numero INTEGER,
	capacite_acceuil integer,
	est_ouvert BOOL,
	secteur_id INT
);

CREATE TABLE secteur (
	id INTEGER PRIMARY KEY AUTO_INCREMENT  ,
	theme VARCHAR(100) UNIQUE,
	horaire_ouverture TIME,
	horaire_fermeture TIME
);


ALTER TABLE espece
	DROP COLUMN est_sensible;
    
ALTER TABLE espece
	ADD COLUMN regime VARCHAR(100) NOT NULL;
    
ALTER TABLE enclos
	MODIFY numero VARCHAR(50) NOT NULL;
    
INSERT INTO secteur (theme,horaire_ouverture,horaire_fermeture)
        VALUES  ('jungle','09:00:00','17:00:00'),
                        ('foret','09:00:00','17:00:00'),
                        ('montagne','10:00:00','15:00:00'),
                        ('désert','08:00:00','14:00:00');
            
            
    INSERT INTO espece (nom,regime)
                values ('tigre','viande'),
                ('marmotte', 'végétarien')
                ;
        
       INSERT INTO enclos (numero, secteur_id)
                values ('2b', 1),
					   ('1', 3);
        
        
        INSERT INTO animal (nom, date_de_naissance, enclos_id, espece_id, poids, taille)
            VALUES  ('tigre 1', '2002-11-24', 1, 1, 34, 1.26),
					('tigre 2', '2002-08-13', 1, 1, 42, 1.18),
                    ('Marmotte 1' , '2012-01-04', 2, 2, 6, 0.68);


UPDATE espece
SET est_dangeureux = true
WHERE id = 1;

UPDATE enclos
SET est_ouvert = true
WHERE numero = '2b';

UPDATE enclos
SET numero = '1m'
WHERE numero = '1';

UPDATE secteur
SET horaire_ouverture = '08:00';

DELETE FROM animal
WHERE nom = 'tigre 2';


SELECT * FROM animal
WHERE poids BETWEEN 5 AND 20;

/*-> Le nom, prénom et email des clients dont le prénom est "Julien"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'Julien';

/*-> Le nom, prénom et email des clients dont l'email termine par "@gmail.com"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com';

/*-> toutes les commandes  non payées*/
SELECT *
FROM full_order
WHERE is_paid = false;

/*-> toutes les commandes  payées mais non livré*/
SELECT *
FROM full_order
WHERE is_paid = true
AND shipment_date IS NULL;

/*-> toutes les commandes  livré hors de France*/
SELECT *
FROM full_order
WHERE shipment_date IS NOT NULL
AND shipment_country <> 'France'
;

/*-> toutes les commandes au montant de plus 8000€ 
ordonnées du plus grand au plus petit*/
SELECT *
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC;

/*-> La commande au montant le plus bas (une seule)*/
SELECT *
FROM full_order
ORDER BY amount
LIMIT 1;

/*-> toutes les commandes réglé en Cash en 2022 livré en 
France dont le montant est inférieur à 5000 € de la 
plus récente à la plus ancienne*/
SELECT *
FROM full_order
WHERE payment_type ='Cash'
AND payment_date BETWEEN '2022-01-01' AND '2022-12-31'
AND shipment_country = 'France'
AND amount < 5000
ORDER BY payment_date DESC; 


SELECT *
FROM full_order
WHERE payment_type ='Cash'
AND payment_date LIKE '2022%'
AND shipment_country = 'France'
AND amount < 5000
ORDER BY payment_date DESC; 


SELECT *
FROM full_order
WHERE payment_type ='Cash'
AND YEAR (payment_date) = 2022
AND shipment_country = 'France'
AND amount < 5000
ORDER BY payment_date DESC; 



/*-> toutes les commandes payés par carte ou payé aprés le 15/10/2021*/

SELECT *
FROM full_order
WHERE payment_type = 'Credit Card'
OR payment_date > '2021-10-15'
ORDER BY payment_date;



/*-> les 3 dernières commandes envoyées en France*/
SELECT *
FROM full_order
WHERE shipment_country = 'France'
ORDER BY date DESC
LIMIT 3;


/*-> les 10 commandes aux montants les plus élevés passé 
sur l'année 2021*/
SELECT *
FROM full_order
WHERE YEAR(date) = 2021
ORDER BY amount DESC
LIMIT 10;

/*-> la somme des commandes non payés*/
SELECT ROUND(SUM(amount), 2) AS total_amount
FROM full_order
WHERE is_paid = false;

/*-> la moyenne des montants des commandes payés en cash*/
SELECT ROUND(AVG(amount), 2) AS moyenne_des_commandes
FROM full_order
WHERE payment_type = 'Cash';


/*-> le nombre de client dont le nom est "Laporte"*/
SELECT COUNT(id)
FROM full_order
WHERE customer_lastname = 'Laporte';

/*-> Le nombre de jour Maximum entre la date de payment 
et la date de livraison -> DATEDIFF()*/
SELECT MAX(DATEDIFF(payment_date, date)) AS delai_maximum
FROM full_order
;

/*-> Le délai moyen (en jour) de réglement d'une commande*/
SELECT ROUND(AVG(DATEDIFF(payment_date, date))) AS delai_moyen
FROM full_order
;

/*-> le nombre de commande payés en chèque sur 2021*/
SELECT COUNT(id)
FROM full_order
WHERE payment_type = 'Check'
AND YEAR(date) = 2021;


SELECT is_paid, COUNT(*) AS nb_commande
FROM full_order
GROUP BY  is_paid
 HAVING nb_commande > 5000
;

/*-> Le montant total des commandes par type de paiement*/
SELECT payment_type, YEAR(date), ROUND(SUM(amount), 2) AS montant_commande
FROM full_order
WHERE is_paid = true
GROUP BY payment_type, YEAR(date)
ORDER BY payment_type;

SELECT * FROM full_order;

/*-> La moyenne des montants des commandes par Pays*/
SELECT shipment_country, ROUND(AVG(amount), 2) AS moyenne_commande
FROM full_order
WHERE shipment_date IS NOT NULL
GROUP BY shipment_country
ORDER BY moyenne_commande DESC;

/*-> Par année la somme des commandes*/
SELECT YEAR(date), round(SUM(amount), 2) AS montant_commande
FROM full_order
GROUP BY YEAR(date)
ORDER BY YEAR(date);

/*-> Liste des clients (nom, prénom) qui ont au moins deux commandes*/
SELECT customer_lastname, customer_firstname, ROUND(COUNT(id)) AS nb_commande
FROM full_order
GROUP BY customer_lastname, customer_firstname
	HAVING COUNT(id) >= 2
ORDER BY customer_lastname, customer_firstname;

/*-> Liste des clients (nom, prénom) avec le montant de leur commande
la plus élevé en 2021*/
SELECT 2021, 
		customer_lastname, 
        customer_firstname, 
        ROUND(MAX(amount), 2) AS montant_commande
FROM full_order
WHERE YEAR(date) = 2021
GROUP BY  customer_lastname, customer_firstname
ORDER BY customer_lastname, customer_firstname;

SELECT * 
FROM joueur jo
	INNER JOIN equipe eq ON  eq.id = jo.equipe_id;
    
    
SELECT * FROM animal;
SELECT * FROM espece;

SELECT *
FROM animal
	JOIN espece ON animal.espece_id = espece.id
;


SELECT *
FROM animal, espece
WHERE animal.espece_id = espece.id
;

SELECT * FROM customer;
SELECT * FROM bill;
SELECT * FROM line_item;
SELECT * FROM product;
SELECT * FROM category;


/*-> Pour chaque client (nom, prénom) remonter le nombre de facture associé*/
SELECT cu.lastname, cu.firstname, COUNT(bi.id)
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
GROUP BY cu.id
ORDER BY cu.lastname, cu.firstname
;


SELECT *
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
;


/*-> Pour chaque catégorie la moyenne des prix de produits associés*/

SELECT ca.label, ROUND(AVG(pr.unit_price), 2) AS moyenne_produits
FROM category ca 
	JOIN product pr ON pr.category_id = ca.id
GROUP BY ca.label
ORDER BY ca.label
;


/*-> Pour Chaque produit la quantité commandée depuis le 01/01/2021*/

SELECT pr.id, pr.name, SUM(li.quantity)
FROM product pr
	JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON li.bill_id = bi.id
WHERE bi.date >= '2021-01-01'
GROUP BY pr.id
ORDER BY pr.name
;

ALTER TABLE animal
ADD CONSTRAINT FK_animal_espece
FOREIGN KEY animal(espece_id)
REFERENCES espece(id)
ON DELETE CASCADE;

SELECT * FROM animal;
DELETE FROM espece WHERE id = 5;

/*-> La liste des Facture (ref, date) qui ont plus de 2 produits différends commandé*/

SELECT bi.id, bi.ref, bi.date, COUNT(li.product_id) AS nb_produit
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
GROUP BY bi.id
	HAVING nb_produit > 2
;

/*-> Pour chaque Facture afficher le montant total*/

SELECT bi.id, bi.ref, SUM(li.quantity * pr.unit_price) AS total_price
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
;


/*-> Pour chaque client compter le nombre de produit différents qu'il a commandé*/

SELECT cu.lastname, cu.firstname, COUNT(li.product_id) AS nb_pr
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
    JOIN line_item li ON bi.id = li.bill_id
    JOIN product pr ON li.product_id = pr.id
GROUP BY cu.lastname, cu.firstname
ORDER BY cu.lastname, cu.firstname
;

/*Requête de controle*/
SELECT cu.lastname, cu.firstname, li.product_id
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
    JOIN line_item li ON bi.id = li.bill_id
    JOIN product pr ON li.product_id = pr.id
ORDER BY cu.lastname, cu.firstname
;

CURRENT_DATE()
CURDATE()

/*-> Pour chaque produit compter le nombre de client différents qu'ils l'ont commandé*/

SELECT pr.name, COUNT(cu.id) AS nb_client
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
    JOIN line_item li ON bi.id = li.bill_id
    JOIN product pr ON li.product_id = pr.id
GROUP BY pr.name
ORDER BY pr.name
;

/*Requête de controle*/
SELECT pr.name, cu.id
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
    JOIN line_item li ON bi.id = li.bill_id
    JOIN product pr ON li.product_id = pr.id
ORDER BY pr.name
;

CREATE TABLE apprenant (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom VARCHAR(50) NOT NULL ,
    prenom VARCHAR(50) NOT NULL ,
    entreprise VARCHAR(50)
);

CREATE TABLE formation (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    description LONGTEXT NULL,
    date DATE NOT NULL,
    formateur VARCHAR(50)
);

CREATE TABLE apprenant_formation (
	apprenant_id INT NOT NULL,
	formation_id INT NOT NULL
);


ALTER TABLE apprenant_formation
	ADD CONSTRAINT FK_apprenant_formation_apprenant
    FOREIGN KEY apprenant_formation(apprenant_id)
    REFERENCES apprenant(id);

ALTER TABLE apprenant_formation
	ADD CONSTRAINT FK_apprenant_formation_formation
    FOREIGN KEY apprenant_formation(formation_id)
    REFERENCES formation(id);
    
    
    
    
INSERT INTO apprenant (nom, prenom, entreprise)
VALUES ('Fernandes', 'Jorge', 'EIFFAGE');



INSERT INTO formation (libelle, description, date, formateur)
VALUES 
	('SQL - Initiation', 'Gestion du SQL', '2023-12-04', 'Thomas Aldaitz'), 
    ('SQL - Approfondissement', 'Approfondissement du SQL', '2023-12-07', 'Thomas ALdaitz')
;

SELECT * FROM apprenant;
SELECT * FROM formation;
SELECT * FROM apprenant_formation;


INSERT INTO apprenant_formation (apprenant_id, formation_id)
VALUES (1, 1) , (1, 2);

INSERT INTO apprenant_formation (apprenant_id, formation_id)
VALUES (2, 1) , (2, 2), (3, 1) , (3, 2);



SELECT apprenant.nom, apprenant.prenom, apprenant.entreprise, COUNT(formation_id)
FROM apprenant_formation
	RIGHT JOIN apprenant ON apprenant.id = apprenant_formation.apprenant_id
GROUP BY apprenant.entreprise, apprenant.nom, apprenant.prenom
ORDER BY apprenant.entreprise
;



/*-> pour chaque catégorie de produit la somme des facture payées*/

SELECT ca.label, SUM(pr.unit_price * li.quantity) AS total
FROM category ca
	JOIN product pr ON pr.category_id = ca.id
    JOIN line_item li ON li.product_id = pr.id
GROUP BY ca.id
ORDER BY ca.label
;

/*-> par Année la moyenne d'age des clients*/

SELECT YEAR(bi.date) AS Annee, ROUND(AVG(timestampdiff(YEAR, cu.date_of_birth, bi.date))) AS Moyenne_age
FROM bill bi
	JOIN customer cu ON cu.id = bi.customer_id
GROUP BY Annee
ORDER BY Annee
;


/*-> les nom, prénom et num de tel des clients qui ont commandé des produit de 
camping ces deux dernières années*/

SELECT cu.lastname, cu.firstname, cu.phone_number
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
WHERE ca.label = 'Camping'
AND bi.date > '2021-12-06'
GROUP BY cu.id
ORDER BY cu.lastname, cu.firstname
;


/*-> La moyenne d'age des consomateurs pour chaque catégorie de produit*/

SELECT ca.label, ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, CURDATE()))) AS moyenne_age
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
GROUP BY ca.label
ORDER BY ca.label
;

/*-> la liste des produits, avec le nom de leur catégorie, commandés plus de 30 unités
en 2022*/
SELECT pr.id, pr.name, ca.label, SUM(li.quantity) AS unités
FROM product pr
	JOIN category ca ON ca.id = pr.category_id
    JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON bi.id = li.bill_id
WHERE YEAR(bi.date) = 2022
GROUP BY pr.id
	HAVING unités > 30
ORDER BY pr.id
;



SELECT *, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())
FROM customer 
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) IN (
	SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, CURDATE()))) AS moyenne_age
	FROM customer cu
		JOIN bill bi ON bi.customer_id = cu.id
		JOIN line_item li ON li.bill_id = bi.id
		JOIN product pr ON li.product_id = pr.id
		JOIN category ca ON pr.category_id = ca.id
	GROUP BY ca.label
	ORDER BY ca.label
)
;

EXPLAIN SELECT * 
FROM bill
WHERE customer_id IN (
	SELECT id
	FROM customer 
	WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) IN (
		SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, CURDATE()))) AS moyenne_age
		FROM customer cu
			JOIN bill bi ON bi.customer_id = cu.id
			JOIN line_item li ON li.bill_id = bi.id
			JOIN product pr ON li.product_id = pr.id
			JOIN category ca ON pr.category_id = ca.id
		GROUP BY ca.label
		ORDER BY ca.label
	)
);


SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, CURDATE()))) AS moyenne_age
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
GROUP BY ca.label
ORDER BY ca.label
;



ALTER TABLE customer
	ADD COLUMN is_vip BOOL NULL;
    
SELECT bi.customer_id
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
	HAVING SUM(li.quantity * pr.unit_price) > 10000
ORDER BY bi.id
;


UPDATE customer
SET is_vip = 1
WHERE id IN (
	SELECT bi.customer_id
	FROM bill bi
		JOIN line_item li ON li.bill_id = bi.id
		JOIN product pr ON li.product_id = pr.id
	GROUP BY bi.id
		HAVING SUM(li.quantity * pr.unit_price) > 10000
	ORDER BY bi.id
);


SELECT * FROM customer;

CREATE VIEW view_factures_avec_montant AS

SELECT bi.*, SUM(li.quantity * pr.unit_price) AS amount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
;

/*-> le nom, prénom et somme des factures des 3 clients qui 
ont passé le plus grand nombre de facture*/

SELECT cu.lastname, cu.firstname, SUM(vf.amount) AS Somme, COUNT(vf.id) AS nb_facture
FROM view_factures_avec_montant vf
	JOIN customer cu ON cu.id = vf.customer_id
GROUP BY cu.id
ORDER BY nb_facture DESC
LIMIT 3
;

/*-> le nom, prénom et (somme des factures) des 3 clients qui ont passé les factures 
les plus chers*/

SELECT cu.lastname, cu.firstname, SUM(vf.amount) AS Somme, MAX(vf.amount) AS facture_la_plus_chere
FROM view_factures_avec_montant vf
	JOIN customer cu ON cu.id = vf.customer_id
GROUP BY cu.id
ORDER BY facture_la_plus_chere DESC
LIMIT 3
;

/*-> le nom, prénom et somme des factures des 3 clients qui ont  le total des factures 
les plus élevés*/

SELECT cu.lastname, cu.firstname, SUM(vf.amount) AS Somme
FROM view_factures_avec_montant vf
	JOIN customer cu ON cu.id = vf.customer_id
GROUP BY cu.id
ORDER BY Somme DESC
LIMIT 3
;

SELECT * FROM apprenant;
SELECT * FROM formation;
SELECT * FROM apprenant_formation;

DELIMITER //
CREATE PROCEDURE raz_affectations(nb_ligne INT)
BEGIN
 
 DELETE FROM apprenant_formation LIMIT nb_ligne;

END//

CALL raz_affectations(5);

DROP PROCEDURE update_vips;

DELIMITER //
CREATE PROCEDURE update_vips(plafond INT)
BEGIN

    UPDATE customer SET is_vip = false;

	UPDATE customer
	SET is_vip = true
	WHERE id IN (
		SELECT vf.customer_id
		FROM view_factures_avec_montant vf
		WHERE vf.amount > plafond
        AND vf.date > TIMESTAMPADD(YEAR, -1, CURDATE())
	);
END//


UPDATE customer SET is_vip = 1;

EXPLAIN SELECT COUNT(*) FROM customer WHERE is_vip = 1;

CALL update_vips(5000);

SELECT lastname AS nom, firstname AS plus, 0 AS prix FROM customer

UNION ALL

SELECT name, '', unit_price FROM product;




WITH
  client_moyen AS (
	SELECT id
	FROM customer 
	WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) IN (
		SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, CURDATE()))) AS moyenne_age
		FROM customer cu
			JOIN bill bi ON bi.customer_id = cu.id
			JOIN line_item li ON li.bill_id = bi.id
			JOIN product pr ON li.product_id = pr.id
			JOIN category ca ON pr.category_id = ca.id
		GROUP BY ca.label
		ORDER BY ca.label
	)
  )
    
SELECT * 
FROM bill bi
	JOIN client_moyen ON bi.customer_id = client_moyen.id
;

DROP TABLE actor;
DROP TABLE director;
DROP TABLE movie;
DROP TABLE user;
DROP TABLE viewing;

CREATE TABLE actor (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL ,
        lastname VARCHAR(50) NOT NULL,
        firstname VARCHAR(50) NOT NULL
);

CREATE TABLE director (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL ,
        lastname VARCHAR(50) NOT NULL,
        firstname VARCHAR(50) NOT NULL
);

CREATE TABLE viewing (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL ,
        date DATETIME NOT NULL,
        movie_id INT NOT NULL,
        user_id INT NOT NULL
);

CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL ,
        lastname VARCHAR(50) NOT NULL,
        firstname VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL,
                phone_number VARCHAR(20) NOT NULL,
                subscription_type VARCHAR(50) NOT NULL
);

CREATE TABLE movie (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL ,
        title VARCHAR(100) NOT NULL,
        country VARCHAR(50) NOT NULL,
        description LONGTEXT,
		release_year DATE ,
        duration INT,
		rating INT,
		director_id INT NOT NULL
);

CREATE TABLE actor_movie (
	movie_id INT NOT NULL,
	actor_id INT NOT NULL
);

ALTER TABLE movie
ADD CONSTRAINT FK_movie_director
FOREIGN KEY movie(director_id)
REFERENCES director(id);

ALTER TABLE actor_movie
ADD CONSTRAINT FK_actor_movie_actor
FOREIGN KEY actor_movie(actor_id)
REFERENCES actor(id);

ALTER TABLE actor_movie
ADD CONSTRAINT FK_actor_movie_movie
FOREIGN KEY actor_movie(movie_id)
REFERENCES movie(id);

ALTER TABLE viewing
ADD CONSTRAINT FK_viewing_movie
FOREIGN KEY viewing(movie_id)
REFERENCES movie(id);

ALTER TABLE viewing
ADD CONSTRAINT FK_viewing_user
FOREIGN KEY viewing(user_id)
REFERENCES user(id);

CREATE TABLE import_netflix (
	show_id VARCHAR(250),
	type VARCHAR(250),
	title VARCHAR(250),
	director VARCHAR(250),
	cast TEXT,
	country VARCHAR(250),
	date VARCHAR(250),
	year VARCHAR(250),
	release_year VARCHAR(250),
	rating VARCHAR(250),
	duration VARCHAR(250),
	listed_in TEXT,
	description TEXT
);


USE netflix;

LOAD DATA LOCAL INFILE 'C:\\formations\\SQL\\netflix.csv'
INTO TABLE import_netflix
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;


SET GLOBAL local_infile=1;

SELECT * FROM import_netflix;

SELECT * FROM import_netflix;

ALTER TABLE movie
	MODIFY release_year INT NOT NULL;
    
ALTER TABLE movie
	MODIFY rating VARCHAR(50) NOT NULL;
    
ALTER TABLE movie
	MODIFY title VARCHAR(250) NOT NULL;
    
ALTER TABLE movie
	MODIFY country text NOT NULL;

SELECT * FROM movie;
SELECT * FROM director;

INSERT INTO movie (title, country, description, release_year, duration, rating, director_id)
SELECT 
	title, 
	country, 
	description, 
	release_year, 
	replace(duration, ' min', '') AS duration, 
	rating, 
	1 AS director_id
FROM import_netflix
WHERE type = 'Movie'
AND director <> ''
AND release_year REGEXP '^[0-9]+$' = 1
AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
;


SELECT * FROM movie;

DROP PROCEDURE maj_movie;

DELIMITER //
CREATE PROCEDURE maj_movie()
BEGIN

    /*Gestion des erreurs en transaction*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
		ROLLBACK;
        SELECT ('Une erreur est survenu durant l\'execution de la procédure.') AS Erreur;
    END;

	START TRANSACTION;
    
		DELETE FROM movie;
        DELETE FROM director;
        
        INSERT INTO director (lastname, firstname)
		SELECT 
			SUBSTRING_INDEX(director, ' ', -1) AS lastname,
			SUBSTRING_INDEX(director, ' ', 1) AS firstname
		FROM import_netflix
		WHERE type = 'Movie'
		AND director <> ''
		AND release_year REGEXP '^[0-9]+$' = 1
		AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
        AND show_id = 0
		GROUP BY lastname, firstname
		ORDER BY lastname, firstname
		;
        
        IF (SELECT COUNT(*) FROM movie) = 0
		THEN
			SELECT 'c\'est zéro';
		END IF;
        
        INSERT INTO movie (title, country, description, release_year, duration, rating, director_id)
		SELECT 
			title, 
			country, 
			description, 
			release_year, 
			replace(duration, ' min', '') AS duration, 
			rating, 
			di.id AS director_id
		FROM import_netflix imp
              JOIN director di ON imp.director = CONCAT(di.firstname, ' ', di.lastname)
		WHERE type = 'Movie'
		AND director <> ''
		AND release_year REGEXP '^[0-9]+$' = 1
		AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
		;
    
    COMMIT;
END//



CALL maj_movie();

SELECT * FROM movie;
SELECT * FROM director;

SELECT * FROM import_netflix;

DELETE FROM director;

INSERT INTO director (lastname, firstname)
SELECT 
	SUBSTRING_INDEX(director, ' ', -1) AS lastname,
	SUBSTRING_INDEX(director, ' ', 1) AS firstname
FROM import_netflix
WHERE type = 'Movie'
AND director <> ''
AND release_year REGEXP '^[0-9]+$' = 1
AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
GROUP BY lastname, firstname
ORDER BY lastname, firstname
;

DROP PROCEDURE maj_movie;

DELIMITER //
CREATE PROCEDURE maj_movie()
BEGIN

    /*Gestion des erreurs en transaction*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
                ROLLBACK;
        SELECT ('Une erreur est survenu durant l\'execution de la procédure.') AS Erreur;
    END;

        START TRANSACTION;
    
                DELETE FROM movie;
        DELETE FROM director;
        
        INSERT INTO director (lastname, firstname)
                SELECT 
                        SUBSTRING_INDEX(director, ' ', -1) AS lastname,
                        SUBSTRING_INDEX(director, ' ', 1) AS firstname
                FROM import_netflix
                WHERE type = 'Movie'
                AND director <> ''
                AND release_year REGEXP '^[0-9]+$' = 1
                AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
                GROUP BY lastname, firstname
                ORDER BY lastname, firstname
                ;

                IF (SELECT COUNT(*) FROM director) = 0
                        THEN
                                SELECT 'Table director vide';
                                ROLLBACK ;
                END IF;
       
        INSERT INTO movie (title, country, description, release_year, duration, rating, director_id)
                SELECT 
                        title, 
                        country, 
                        description, 
                        release_year, 
                        replace(duration, ' min', '') AS duration, 
                        rating, 
                        di.id AS director_id
                FROM import_netflix imp
              JOIN director di ON imp.director = CONCAT(di.firstname, ' ', di.lastname)
                WHERE type = 'Movie'
                AND director <> ''
                AND release_year REGEXP '^[0-9]+$' = 1
                AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
                ;
    
    IF (SELECT COUNT(*) FROM movie) = 0
                        THEN
                                SELECT 'Table movie vide';
                                                ROLLBACK ;
                        END IF;
    COMMIT;
END//

CALL maj_movie();


DROP PROCEDURE maj_viewing;

DELIMITER //
CREATE PROCEDURE maj_viewing(nb_viewing INT)
BEGIN

	SET @user_id = (SELECT id FROM user ORDER BY RAND() LIMIT 1);
	SET @film_id = (SELECT id FROM movie ORDER BY RAND() LIMIT 1);
    
    INSERT INTO viewing (user_id, movie_id, date)
    VALUES (@user_id, @film_id, NOW());
    
    /*appel récursif*/
    IF nb_viewing > 0
    THEN CALL maj_viewing(nb_viewing - 1);
    END IF;

END//

CALL maj_viewing(100);

SELECT * FROM viewing;

SET max_sp_recursion_depth = 250;


DROP PROCEDURE save_actor;
DELIMITER //
CREATE PROCEDURE save_actor(acteur TEXT)
BEGIN

	SET @firstname = SUBSTRING_INDEX(acteur, ' ', 1);
	SET @lastname = SUBSTRING_INDEX(acteur, ' ', -1);

	IF (SELECT COUNT(*) FROM actor WHERE firstname = @firstname AND lastname = @lastname) = 0
    THEN
		INSERT INTO actor (lastname, firstname)
		VALUES(@lastname, @firstname);
	END IF;
   
END //


CALL save_actor ('Thomas Aldaitz');

SELECT * FROM actor;


DROP PROCEDURE save_actors;
DELIMITER //
CREATE PROCEDURE save_actors(actors TEXT)
BEGIN

	REPEAT
		SET @actor = SUBSTRING_INDEX(actors, ', ', 1);
		CALL save_actor(@actor);
		
		SET actors =  REPLACE(actors, CONCAT(@actor, ', '), '');
    UNTIL actors = @actor END REPEAT;

END//

DELETE FROM actor;


CALL save_actors('Sami Bouajila, Tracy Gotoas, Samuel Jouy, Nabiha Akkari, Sofia Lesaffre, Salim Kechiouche, Noureddine Farihi, Geert Van Rampelberg, Bakary Diombera');



DELIMITER //
CREATE PROCEDURE import_actors()
BEGIN

	DECLARE done BOOL DEFAULT false;
    DECLARE actors TEXT;
    DECLARE cur CURSOR FOR SELECT cast FROM import_netflix WHERE cast <> '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    OPEN cur;
    read_loop : LOOP
		FETCH cur INTO actors;
        
        IF done THEN LEAVE read_loop;
        END IF;
        
        CALL save_actors(actors);
    END LOOP;
    CLOSE cur;

END//


CALL import_actors();

SELECT COUNT(*) FROM actor;

SELECT 
	YEAR(date), 
    CASE WHEN GROUPING(is_paid) = 1 
		THEN 'Sous-total' 
        ELSE
			CASE WHEN is_paid = 1 THEN 'Payée' ELSE 'NON payée' END
	END AS Statut, 
    SUM(amount)
FROM view_factures_avec_montant
GROUP BY YEAR(date), is_paid WITH ROLLUP
;



WITH factures AS 
     (SELECT cat.label AS categorie, 
	YEAR(bi.date) AS annee, 
    SUM(li.quantity * pr.unit_price) AS total
FROM category cat
	JOIN product pr ON cat.id = pr.category_id
	JOIN line_item li ON li.product_id = pr.id
	JOIN bill bi ON li.bill_id = bi.id
GROUP BY cat.label, YEAR(bi.date))
  

SELECT CASE WHEN GROUPING(categorie) = 1 THEN 'Général' ELSE categorie END, 
       CASE WHEN GROUPING(annee) = 1 THEN 'Sous total' ELSE annee END, 
       SUM(total)
FROM factures
GROUP BY categorie,  annee WITH ROLLUP
;

    SELECT * FROM user;

ALTER TABLE user 
     ADD COLUMN cdate DATETIME;
     
ALTER TABLE user 
     ADD COLUMN mdate DATETIME;
     
     
     
CREATE TRIGGER cdate_trigger BEFORE INSERT ON user
FOR EACH ROW SET NEW.cdate = NOW();

DELIMITER //
CREATE TRIGGER cdate_trigger BEFORE INSERT ON user
FOR EACH ROW
BEGIN


 SET NEW.cdate = NOW();
 
END//

INSERT INTO user(lastname, firstname, email, phone_number, subscription_type)
VALUES ('Aldaitz', 'THomas', 'taldaitz@dawan.fr', '0653143514', 'normal');