
const express = require('express');
const mysql = require('mysql2/promise');
const app = express();
const port = 3000;

app.use(express.json());

// MySQL connection pool
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '@Ftsvolvl9',
    database: 'library_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Books CRUD Endpoints
// Create a book
app.post('/books', async (req, res) => {
    const { title, isbn, publication_year, author_ids } = req.body;
    try {
        const [result] = await pool.query(
            'INSERT INTO Books (title, isbn, publication_year) VALUES (?, ?, ?)',
            [title, isbn, publication_year]
        );
        const bookId = result.insertId;

        // Add authors to Book_Authors
        if (author_ids && author_ids.length > 0) {
            const values = author_ids.map(author_id => [bookId, author_id]);
            await pool.query('INSERT INTO Book_Authors (book_id, author_id) VALUES ?', [values]);
        }

        res.status(201).json({ book_id: bookId, title, isbn, publication_year });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Read all books
app.get('/books', async (req, res) => {
    try {
        const [books] = await pool.query(`
            SELECT b.*, GROUP_CONCAT(a.author_id) as author_ids, GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name)) as authors
            FROM Books b
            LEFT JOIN Book_Authors ba ON b.book_id = ba.book_id
            LEFT JOIN Authors a ON ba.author_id = a.author_id
            GROUP BY b.book_id
        `);
        res.json(books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Read a single book
app.get('/books/:id', async (req, res) => {
    try {
        const [books] = await pool.query(`
            SELECT b.*, GROUP_CONCAT(a.author_id) as author_ids, GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name)) as authors
            FROM Books b
            LEFT JOIN Book_Authors ba ON b.book_id = ba.book_id
            LEFT JOIN Authors a ON ba.author_id = a.author_id
            WHERE b.book_id = ?
            GROUP BY b.book_id
        `, [req.params.id]);
        if (books.length === 0) return res.status(404).json({ error: 'Book not found' });
        res.json(books[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update a book
app.put('/books/:id', async (req, res) => {
    const { title, isbn, publication_year, author_ids } = req.body;
    try {
        await pool.query(
            'UPDATE Books SET title = ?, isbn = ?, publication_year = ? WHERE book_id = ?',
            [title, isbn, publication_year, req.params.id]
        );

        // Update authors
        await pool.query('DELETE FROM Book_Authors WHERE book_id = ?', [req.params.id]);
        if (author_ids && author_ids.length > 0) {
            const values = author_ids.map(author_id => [req.params.id, author_id]);
            await pool.query('INSERT INTO Book_Authors (book_id, author_id) VALUES ?', [values]);
        }

        res.json({ book_id: req.params.id, title, isbn, publication_year });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Delete a book
app.delete('/books/:id', async (req, res) => {
    try {
        const [result] = await pool.query('DELETE FROM Books WHERE book_id = ?', [req.params.id]);
        if (result.affectedRows === 0) return res.status(404).json({ error: 'Book not found' });
        res.status(204).send();
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Authors CRUD Endpoints
// Create an author
app.post('/authors', async (req, res) => {
    const { first_name, last_name, email } = req.body;
    try {
        const [result] = await pool.query(
            'INSERT INTO Authors (first_name, last_name, email) VALUES (?, ?, ?)',
            [first_name, last_name, email]
        );
        res.status(201).json({ author_id: result.insertId, first_name, last_name, email });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Read all authors
app.get('/authors', async (req, res) => {
    try {
        const [authors] = await pool.query('SELECT * FROM Authors');
        res.json(authors);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Read a single author
app.get('/authors/:id', async (req, res) => {
    try {
        const [authors] = await pool.query('SELECT * FROM Authors WHERE author_id = ?', [req.params.id]);
        if (authors.length === 0) return res.status(404).json({ error: 'Author not found' });
        res.json(authors[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Update an author
app.put('/authors/:id', async (req, res) => {
    const { first_name, last_name, email } = req.body;
    try {
        const [result] = await pool.query(
            'UPDATE Authors SET first_name = ?, last_name = ?, email = ? WHERE author_id = ?',
            [first_name, last_name, email, req.params.id]
        );
        if (result.affectedRows === 0) return res.status(404).json({ error: 'Author not found' });
        res.json({ author_id: req.params.id, first_name, last_name, email });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Delete an author
app.delete('/authors/:id', async (req, res) => {
    try {
        const [result] = await pool.query('DELETE FROM Authors WHERE author_id = ?', [req.params.id]);
        if (result.affectedRows === 0) return res.status(404).json({ error: 'Author not found' });
        res.status(204).send();
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});