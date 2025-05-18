DROP TABLE IF EXISTS cimodules;
DROP TABLE IF EXISTS televisions;
DROP TABLE IF EXISTS remotecontrollers;
DROP TABLE IF EXISTS wallbrackets;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE products
(
    id SERIAL PRIMARY KEY,
    name VARCHAR (255),
    brand VARCHAR (255),
    price DECIMAL,
    currentStock INT,
    dateSold DATE,
    type VARCHAR (255)
);

CREATE TABLE remotecontrollers
(
    product_id INT PRIMARY KEY REFERENCES products(id),
    smart BOOLEAN,
    batteryType VARCHAR (255)
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
    FOREIGN KEY (remotecontroller_id) REFERENCES remotecontrollers(product_id)
);

CREATE TABLE cimodules
(
    product_id INT PRIMARY KEY REFERENCES products(id),
    provider VARCHAR (255),
    encoding VARCHAR (255),
    television_id INT,
    FOREIGN KEY (television_id) REFERENCES televisions(product_id)
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
    username VARCHAR (255),
    password VARCHAR (255),
    address VARCHAR (255),
    function VARCHAR (255),
    loonschaal INT,
    vakantiedagen INT
);

INSERT INTO products (name, brand, price, currentStock, type)
VALUES
    ('Samsung TV', 'Samsung', 899.99, 10, 'television'),
    ('Takijitu', 'Chinees merk', 1000.99, 6, 'television'),
    ('Wallie', 'E', 500.00, 7, 'wallbracket'),
    ('Ballie', 'E', 400.00, 6, 'wallbracket'),
    ('XSD', 'Nokia', 29.00, 8, 'remotecontroller'),
    ('Remote C', 'Apple', 45.31, 2, 'remotecontroller'),
    ('CIM', 'Brandname', 29.50, 3, 'cimodule'),
    ('PIM C', 'No inspiration', 35.36, 7, 'cimodule'),
    ('Extra CI Plus Pro', 'CPP', 27.99, 3, 'cimodule')
    RETURNING id;

INSERT INTO televisions (product_id, height, width, schermKwaliteit, schermType, wifi, smartTv, voiceControl, HDR)
VALUES
    (1, 70.0, 120.0, '4K', 'OLED', true, true, false, true),
    (2, 75.0, 130.0, '5K', 'Super', false, true, true, true);

INSERT INTO wallbrackets (product_id, adjustable, height, width)
VALUES
    (3, true, 50.00, 2.00),
    (4, false, 55.00, 3.00);

INSERT INTO remotecontrollers (product_id, smart, batterytype)
VALUES
    (5, false, 'AA'),
    (6, true, 'AAA');

INSERT INTO cimodules (product_id, provider, encoding, television_id)
VALUES
    (7, null, null, 1),
    (8, null, null, 1),
    (9, 'tele2', 'encode678', 2);

UPDATE televisions
SET remotecontroller_id = 5
WHERE product_id = 1;

UPDATE televisions
SET remotecontroller_id = 6
WHERE product_id = 2;

SELECT *
FROM products
         LEFT JOIN televisions ON televisions.product_id = products.id
         LEFT JOIN wallbrackets ON wallbrackets.product_id = products.id
         LEFT JOIN cimodules ON cimodules.product_id = products.id
         LEFT JOIN remotecontrollers ON remotecontrollers.product_id = products.id
ORDER BY products.id;