-- Create the database
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Create the Authors table
CREATE TABLE IF NOT EXISTS Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Create the Books table
CREATE TABLE IF NOT EXISTS Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    publication_year INT NOT NULL
);

-- Create the Book_Authors junction table (M-M relationship between Books and Authors)
CREATE TABLE IF NOT EXISTS Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- Insert sample data into Authors
INSERT IGNORE INTO Authors (first_name, last_name, email) VALUES
('J.K.', 'Rowling', 'jk.rowling@example.com'),
('George', 'Orwell', 'george.orwell@example.com'),
('Neil', 'Gaiman', 'neil.gaiman@example.com');

-- Insert sample data into Books
INSERT IGNORE INTO Books (title, isbn, publication_year) VALUES
('Harry Potter and the Sorcerer''s Stone', '9780590353427', 1997),
('1984', '9780451524935', 1949),
('American Gods', '9780380789030', 2001),
('Good Omens', '9780060853983', 1990);

-- Insert sample data into Book_Authors
INSERT IGNORE INTO Book_Authors (book_id, author_id) VALUES
(1, 1), -- Harry Potter by J.K. Rowling
(2, 2), -- 1984 by George Orwell
(3, 3), -- American Gods by Neil Gaiman
(4, 3); -- Good Omens by Neil Gaiman