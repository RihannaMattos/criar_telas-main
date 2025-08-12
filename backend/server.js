const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Inicializar banco de dados
const db = new sqlite3.Database('database.db');

db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rm TEXT UNIQUE NOT NULL,
    senha TEXT NOT NULL
  )`);
});

// Login
app.post('/api/auth/login', (req, res) => {
  const { rm, senha } = req.body;
  
  db.get('SELECT * FROM users WHERE rm = ?', [rm], async (err, user) => {
    if (err) return res.status(500).json({ error: 'Erro no servidor' });
    if (!user) return res.status(401).json({ error: 'RM não encontrado' });
    
    const validPassword = await bcrypt.compare(senha, user.senha);
    if (!validPassword) return res.status(401).json({ error: 'Senha incorreta' });
    
    res.json({ message: 'Login realizado com sucesso', rm: user.rm });
  });
});

// Registro
app.post('/api/auth/register', async (req, res) => {
  const { rm, senha } = req.body;
  
  const hashedPassword = await bcrypt.hash(senha, 10);
  
  db.run('INSERT INTO users (rm, senha) VALUES (?, ?)', [rm, hashedPassword], function(err) {
    if (err) {
      if (err.code === 'SQLITE_CONSTRAINT') {
        return res.status(400).json({ error: 'RM já cadastrado' });
      }
      return res.status(500).json({ error: 'Erro no servidor' });
    }
    res.status(201).json({ message: 'Usuário cadastrado com sucesso' });
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});