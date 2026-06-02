DROP DATABASE IF EXISTS nexusdb;

CREATE DATABASE IF NOT EXISTS nexusdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE nexusdb;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS productlines;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS orderdetails;

CREATE TABLE roles
(
    id   BIGINT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255)          NOT NULL,
    CONSTRAINT pk_roles PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE roles
    ADD CONSTRAINT uc_roles_name UNIQUE (name);

CREATE TABLE users
(
    id       BIGINT AUTO_INCREMENT NOT NULL,
    email    VARCHAR(255)          NULL,
    password VARCHAR(255)          NULL,
    username VARCHAR(255)          NULL,
    roleId   BIGINT                NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE users
    ADD CONSTRAINT uc_users_email UNIQUE (email);

ALTER TABLE users
    ADD CONSTRAINT uc_users_username UNIQUE (username);

ALTER TABLE users
    ADD CONSTRAINT FK_USERS_ON_ROLEID FOREIGN KEY (roleId) REFERENCES roles (id);

CREATE TABLE productlines
(
    productLine     VARCHAR(50)   NOT NULL,
    textDescription VARCHAR(4000) NULL,
    htmlDescription MEDIUMTEXT    NULL,
    image           MEDIUMBLOB    NULL,
    CONSTRAINT pk_productlines PRIMARY KEY (productLine)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products
(
    productCode        VARCHAR(15)    NOT NULL,
    productName        VARCHAR(70)    NOT NULL,
    productLine        VARCHAR(50)    NOT NULL,
    productVendor      VARCHAR(50)    NOT NULL,
    productDescription TEXT           NOT NULL,
    quantityInStock    SMALLINT       NOT NULL,
    buyPrice           DECIMAL(10, 2) NOT NULL,
    MSRP               DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (productCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE products
    ADD CONSTRAINT FK_PRODUCTS_ON_PRODUCTLINE FOREIGN KEY (productLine) REFERENCES productlines (productLine);

CREATE INDEX productLine ON products (productLine);

CREATE TABLE customers
(
    customerNumber   INT AUTO_INCREMENT NOT NULL,
    customerName     VARCHAR(50)        NOT NULL,
    contactLastName  VARCHAR(50)        NOT NULL,
    contactFirstName VARCHAR(50)        NOT NULL,
    phone            VARCHAR(50)        NOT NULL,
    addressLine1     VARCHAR(50)        NOT NULL,
    addressLine2     VARCHAR(50)        NULL,
    city             VARCHAR(50)        NOT NULL,
    state            VARCHAR(50)        NULL,
    postalCode       VARCHAR(15)        NULL,
    country          VARCHAR(50)        NOT NULL,
    userId           BIGINT             NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customerNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE customers
    ADD CONSTRAINT uc_customers_userid UNIQUE (userId);

ALTER TABLE customers
    ADD CONSTRAINT FK_CUSTOMERS_ON_USERID FOREIGN KEY (userId) REFERENCES users (id);

CREATE TABLE employees
(
    employeeNumber INT AUTO_INCREMENT NOT NULL,
    lastName       VARCHAR(50)        NOT NULL,
    firstName      VARCHAR(50)        NOT NULL,
    reportsTo      INT                NULL,
    userId         BIGINT             NULL,
    jobTitle       VARCHAR(50)        NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (employeeNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE employees
    ADD CONSTRAINT uc_employees_userid UNIQUE (userId);

ALTER TABLE employees
    ADD CONSTRAINT FK_EMPLOYEES_ON_REPORTSTO FOREIGN KEY (reportsTo) REFERENCES employees (employeeNumber);

CREATE INDEX reportsTo ON employees (reportsTo);

ALTER TABLE employees
    ADD CONSTRAINT FK_EMPLOYEES_ON_USERID FOREIGN KEY (userId) REFERENCES users (id);

CREATE TABLE orders
(
    orderNumber    INT AUTO_INCREMENT NOT NULL,
    orderDate      date               NOT NULL,
    requiredDate   date               NOT NULL,
    shippedDate    date               NULL,
    status         VARCHAR(15)        NOT NULL,
    comments       TEXT               NULL,
    customerNumber INT                NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (orderNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE orders
    ADD CONSTRAINT FK_ORDERS_ON_CUSTOMERNUMBER FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber);

CREATE INDEX customerNumber ON orders (customerNumber);

CREATE TABLE orderdetails
(
    quantityOrdered INT            NOT NULL,
    priceEach       DECIMAL(10, 2) NOT NULL,
    orderNumber     INT            NOT NULL,
    productCode     VARCHAR(15)    NOT NULL,
    CONSTRAINT pk_orderdetails PRIMARY KEY (orderNumber, productCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE orderdetails
    ADD CONSTRAINT FK_ORDERDETAILS_ON_ORDERNUMBER FOREIGN KEY (orderNumber) REFERENCES orders (orderNumber);

ALTER TABLE orderdetails
    ADD CONSTRAINT FK_ORDERDETAILS_ON_PRODUCTCODE FOREIGN KEY (productCode) REFERENCES products (productCode);

CREATE INDEX productCode ON orderdetails (productCode);

CREATE TABLE payments
(
    paymentDate    date           NOT NULL,
    amount         DECIMAL(10, 2) NOT NULL,
    customerNumber INT            NOT NULL,
    checkNumber    VARCHAR(50)    NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (customerNumber, checkNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE payments
    ADD CONSTRAINT FK_PAYMENTS_ON_CUSTOMERNUMBER FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber);

