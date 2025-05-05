PLP Library Management 

Question 1: Build a Complete Database Management System
Objective:
Design and implement a full-featured database using only MySQL.

What to do:

Choose a real-world use case (e.g., Library Management, Student Records, Clinic Booking System, Inventory Tracking, etc.)

Create a well-structured relational database using SQL.

Use SQL to create:

Tables with proper constraints (PK, FK, NOT NULL, UNIQUE)

Relationships (1-1, 1-M, M-M where needed)

Deliverables:

A single .sql file containing your:

CREATE TABLE statements

Sample  data


the Script creates a MySQL database (libraryManagement_db) for a Library Management System. It includes tables for managing authors, books, book-author relationships, members, and book loans, with appropriate constraints and sample data.

Authors: Stores author details (ID, name, email, birth date).





Primary Key: author_id



Unique: email



Books: Stores book details (ID, title, ISBN, publication year, copies).





Primary Key: book_id



Unique: isbn



Constraints: total_copies >= 0, available_copies >= 0 and <= total_copies



Book_Authors: Junction table for many-to-many relationship between Books and Authors.





Primary Key: (book_id, author_id)



Foreign Keys: book_id (Books), author_id (Authors)



Members: Stores member details (ID, name, email, phone, join date).





Primary Key: member_id



Unique: email



Loans: Tracks book loans (ID, book, member, dates).





Primary Key: loan_id



Foreign Keys: book_id (Books), member_id (Members)


Question 2: Create a Simple CRUD API Using MySQL + Programming

Objective:
Combine your MySQL skills with a programming language (Python or JavaScript) to create a working CRUD API.

What to do:

Choose any use case (e.g., Task Manager, Contact Book, Student Portal)

Design your database schema in MySQL (at least 2–3 tables)

Build an API using:

Node.js + Express (if using JavaScript)

Library Management API

This is a Node.js/Express API for managing a library's books and authors, with full CRUD (Create, Read, Update, Delete) functionality. It uses MySQL as the database and supports a many-to-many relationship between books and authors.

Prerequisites





Node.js (v14 or later): Download



MySQL (v5.7 or later): Download



Git (optional, for cloning): Download



A tool like Postman or curl for testing API endpoints.

Project Setup

1. Clone or Set Up the Project





If using Git, clone the repository:

git clone <repository-url>
cd library-api



Alternatively, create a project directory and add the following files:





server.js (the provided Node.js/Express code)



package.json (see below)



library_db.sql (the database schema and sample data)

2. Install Dependencies





Create a package.json file with the following content:

{
    "name": "library-api",
    "version": "1.0.0",
    "description": "CRUD API for Library Management System",
    "main": "server.js",
    "scripts": {
        "start": "node server.js"
    },
    "dependencies": {
        "express": "^4.18.2",
        "mysql2": "^3.6.5"
    }
}



Run the following command in the project directory to install dependencies:

npm install



This installs express and mysql2. Verify the node_modules folder is created.

3. Set Up the MySQL Database





Ensure MySQL is installed and running:

mysql -u root -p



Use the provided library_db.sql file to create the database and populate sample data. Run:

SOURCE path/to/library_db.sql;



The library_db.sql file should contain:

CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE IF NOT EXISTS Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_year INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

INSERT IGNORE INTO Authors (first_name, last_name, email) VALUES
('J.K.', 'Rowling', 'jk.rowling@example.com'),
('George', 'Orwell', 'george.orwell@example.com'),
('Neil', 'Gaiman', 'neil.gaiman@example.com');

INSERT IGNORE INTO Books (title, isbn, publication_year) VALUES
('Harry Potter and the Sorcerer''s Stone', '9780590353427', 1997),
('1984', '9780451524935', 1949),
('American Gods', '9780380789030', 2001),
('Good Omens', '9780060853983', 1990);

INSERT IGNORE INTO Book_Authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 3);

4. Configure the Database Connection





In server.js, ensure the MySQL connection details are correct:

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '@Ftsvolvl9', // Update if different
    database: 'library_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});



Update the password field if your MySQL root password differs.

5. Run the Application





Start the server:

npm start



The server will run at http://localhost:3000. You should see:

Server running at http://localhost:3000

API Endpoints

Books





Create a Book:





POST /books



Body: { "title": "string", "isbn": "string", "publication_year": number, "author_ids": [number] }



Example:

curl -X POST http://localhost:3000/books -H "Content-Type: application/json" -d '{"title":"New Book","isbn":"9781234567890","publication_year":2023,"author_ids":[1,3]}'



Get All Books:





GET /books
Example:
curl http://localhost:3000/books

Get a Single Book
GET /books/:id
Example:
curl http://localhost:3000/books/1



Update a Book:
PUT /books/:id
Body: { "title": "string", "isbn": "string", "publication_year": number, "author_ids": [number] }



Example:
curl -X PUT http://localhost:3000/books/1 -H "Content-Type: application/json" -d '{"title":"Updated Book","isbn":"9781234567890","publication_year":2024,"author_ids":[2]}'



Delete a Book:
DELETE /books/:id



Example:
curl -X DELETE http://localhost:3000/books/1

Authors
Create an Author:
POST /authors
Body: { "first_name": "string", "last_name": "string", "email": "string" }



Example:
curl -X POST http://localhost:3000/authors -H "Content-Type: application/json" -d '{"first_name":"Terry","last_name":"Pratchett","email":"terry.pratchett@example.com"}'

Get All Authors:
GET /authors
Example:
curl http://localhost:3000/authors

Get a Single Author:
GET /authors/:id



Example:
curl http://localhost:3000/authors/1



Update an Author:
PUT /authors/:id
Body: { "first_name": "string", "last_name": "string", "email": "string" }




if you cannot find module 'mysql2/promise':

Ensure you ran npm install in the project directory.

Verify node_modules/mysql2 exists.

Check the host, user, password, and database in server.js.
Ensure library_db exists by running db_schema.sql.



Port Conflicts:
If port 3000 is in use, update the port variable in server.js and restart.



API Returns Errors:
Check the error message in the response (e.g., { "error": "..." }).

Ensure the database has the required tables and data.

The API assumes the database schema in library_db.sql is set up.
Use INSERT IGNORE in library_db.sql to avoid duplicate data issues.
Implement all CRUD operations (Create, Read, Update, Delete)
Connect your API to the MySQL database
