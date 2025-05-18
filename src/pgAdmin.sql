DROP TABLE IF EXISTS televisions_wallbrackets;
DROP TABLE IF EXISTS televisions;
DROP TABLE IF EXISTS cimodules;
DROP TABLE IF EXISTS remotecontrollers;
DROP TABLE IF EXISTS wallbrackets;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE products
(
    id SERIAL PRIMARY KEY,
    name VARCHAR (255) NOT NULL,
    brand VARCHAR (255),
    price DECIMAL(10,2) CONSTRAINT price_positive CHECK (price >=0),
    currentStock INT DEFAULT 0,
    dateSold DATE,
    type VARCHAR (255) -- hiervoor zou ik liever een enum gebruiken, buiten scope voor deze opdracht
);

CREATE TABLE remotecontrollers
(
    product_id INT PRIMARY KEY REFERENCES products(id),
    smart BOOLEAN,
    batteryType VARCHAR (255)
);

CREATE TABLE cimodules
(
    product_id INT PRIMARY KEY REFERENCES products(id),
    provider VARCHAR (255) DEFAULT 'UNKNOWN',
    encoding VARCHAR (255) DEFAULT 'UNKNOWN'
);

CREATE TABLE televisions
(
    product_id INT PRIMARY KEY REFERENCES products(id),
    height DECIMAL,
    width DECIMAL,
    schermKwaliteit VARCHAR (255),
    schermType VARCHAR (255),
    wifi BOOLEAN,
    smartTv BOOLEAN,
    voiceControl BOOLEAN,
    HDR BOOLEAN,
    remotecontroller_id INT UNIQUE,
    cimodule_id INT,
    FOREIGN KEY (remotecontroller_id) REFERENCES remotecontrollers(product_id),
    FOREIGN KEY (cimodule_id) REFERENCES cimodules(product_id)
);

CREATE TABLE wallbrackets
(
    product_id INT PRIMARY KEY REFERENCES products(id),
    adjustable BOOLEAN,
    height DECIMAL,
    width DECIMAL
);

CREATE TABLE users
(
    username VARCHAR (255) PRIMARY KEY UNIQUE,
    password VARCHAR (255), -- moet een hashed waarde zijn, buiten scope voor deze opdracht
    address VARCHAR (255),
    function VARCHAR (255),
    loonschaal INT,
    vakantiedagen INT
);

CREATE TABLE televisions_wallbrackets
(
    televisionWallbracketId SERIAL PRIMARY KEY,
    television_id INT,
    wallbracket_id INT,
    FOREIGN KEY (television_id) REFERENCES televisions (product_id),
    FOREIGN KEY (wallbracket_id) REFERENCES wallbrackets (product_id)
);

INSERT INTO products (name, brand, price, currentStock, type)
VALUES
    ('Samsung TV', 'Samsung', 899.9999, 10, 'television'), -- prijs laat zien dat de check op 2 decimalen achter de komma werkt
    ('Takijitu', 'Chinees merk', 1000.99, 6, 'television'),
    ('Wallie', 'E', 500.00, 7, 'wallbracket'),
    ('Ballie', 'E', 400.00, 6, 'wallbracket'),
    ('XSD', 'Nokia', 29.00, 8, 'remotecontroller'),
    ('Remote C', 'Apple', 45.31, 2, 'remotecontroller'),
    ('CIM', 'Brandname', 29.50, 3, 'cimodule'),
    ('PIM C', 'No inspiration', 35.36, 7, 'cimodule'),
    ('Extra CI Plus Pro', 'CPP', 27.99, DEFAULT, 'cimodule')
    RETURNING id;

INSERT INTO televisions (product_id, height, width, schermKwaliteit, schermType, wifi, smartTv, voiceControl, HDR)
VALUES
    (1, 70.0, 120.0, '4K', 'OLED', true, true, false, true),
    (2, 75.0, 130.0, '5K', 'Super', false, true, true, true);

INSERT INTO wallbrackets (product_id, adjustable, height, width)
VALUES
    (3, true, 50.00, 2.00),
    (4, false, 55.00, 3.00);

INSERT INTO remotecontrollers (product_id, smart, batteryType)
VALUES
    (5, false, 'AA'),
    (6, true, 'AAA');

INSERT INTO cimodules (product_id, provider, encoding)
VALUES
    (7, DEFAULT, DEFAULT),
    (8, DEFAULT, DEFAULT),
    (9, 'tele2', 'encode678');

INSERT INTO televisions_wallbrackets (television_id, wallbracket_id)
VALUES
    (1, 3),
    (1, 4),
    (2, 3);

UPDATE televisions
SET
    remotecontroller_id = CASE product_id
                              WHEN 1 THEN 5
                              WHEN 2 THEN 6
        END,
    cimodule_id = 7
WHERE product_id IN (1,2);

INSERT INTO users (username)
VALUES
    ('Ik'),
    ('Jij');

ALTER TABLE users
    ADD phonenumber VARCHAR (20)
        CHECK (phonenumber ~ '^\+?\d{10,14}$'); -- staat landcodes met + en telefoonnummers tussen 10 en 14 karakters toe

UPDATE users -- voor de update zou er nog een back-up uitgevoerd kunnen worden
SET phonenumber = '+3112345678'
WHERE username = 'Ik';

SELECT *
FROM products
         LEFT JOIN televisions ON televisions.product_id = products.id
         LEFT JOIN wallbrackets ON wallbrackets.product_id = products.id
         LEFT JOIN cimodules ON cimodules.product_id = products.id
         LEFT JOIN remotecontrollers ON remotecontrollers.product_id = products.id
ORDER BY products.id;