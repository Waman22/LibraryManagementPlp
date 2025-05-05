-- Create the database
CREATE DATABASE IF NOT EXISTS libraryManagement_db;
USE libraryManagement_db;

-- Create the Authors table
CREATE TABLE IF NOT EXISTS Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    birth_date DATE
);

-- Create the Books table
CREATE TABLE IF NOT EXISTS Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_year INT NOT NULL,
    total_copies INT NOT NULL CHECK (total_copies >= 0),
    available_copies INT NOT NULL CHECK (available_copies >= 0 AND available_copies <= total_copies)
);

-- Create the Book_Authors junction table (M-M relationship between Books and Authors)
CREATE TABLE IF NOT EXISTS Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- Create the Members table
CREATE TABLE IF NOT EXISTS Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    join_date DATE NOT NULL
);

-- Create the Loans table (M-M relationship between Books and Members)
CREATE TABLE IF NOT EXISTS Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE RESTRICT
);

-- Insert sample data into Authors
INSERT IGNORE INTO Authors (first_name, last_name, email, birth_date) VALUES
('J.K.', 'Rowling', 'jk.rowling@example.com', '1965-07-31'),
('George', 'Orwell', 'george.orwell@example.com', '1903-06-25'),
('Jane', 'Austen', 'jane.austen@example.com', '1775-12-16');

-- Insert sample data into Books
INSERT IGNORE INTO Books (title, isbn, publication_year, total_copies, available_copies) VALUES
('Harry Potter and the Sorcerer\'s Stone', '9780590353427', 1997, 10, 8),
('1984', '9780451524935', 1949, 5, 3),
('Pride and Prejudice', '9780141439518', 1813, 7, 7);

-- Insert sample data into Book_Authors
INSERT IGNORE INTO Book_Authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert sample data into Members
INSERT IGNORE INTO Members (first_name, last_name, email, phone, join_date) VALUES
('Patrice', 'Smith', 'Patrice.smith@gmail.com', '555-0101', '2025-05-15'),
('Peter', 'Johnson', 'Peter.johnson@yahoo.com', '555-0102', '2025-04-20'),
('Brian', 'Williams', 'Brian.williams@gmail.com', '555-0103', '2025-03-10');

-- Insert sample data into Loans
INSERT IGNORE INTO Loans (book_id, member_id, loan_date, due_date, return_date) VALUES
(1, 1, '2025-04-01', '2025-04-15', NULL),
(2, 2, '2025-04-05', '2025-04-19', '2025-04-10'),
(1, 3, '2025-04-10', '2025-04-24', NULL);