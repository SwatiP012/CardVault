const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const jwt = require('jsonwebtoken');
const authenticateToken = require('./middleware/auth_middleware');

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '1h';

// Development user for CardVault
const users = [
  {
    id: 'user_001',
    mobile: '9876543210',
    pin: '1234',
  },
];

// Health check
app.get('/', (req, res) => {
  res.json({
    message: 'CardVault API is running',
  });
});

// Login
app.post('/login', (req, res) => {
  const { mobile, pin } = req.body;

  if (!mobile || !pin) {
    return res.status(400).json({
      message: 'Mobile number and PIN are required.',
    });
  }

  const user = users.find(
    (item) => item.mobile === mobile && item.pin === pin,
  );

  if (!user) {
    return res.status(401).json({
      message: 'Invalid mobile number or PIN.',
    });
  }

  const accessToken = jwt.sign(
    {
      sub: user.id,
      mobile: user.mobile,
    },
    JWT_SECRET,
    {
      expiresIn: JWT_EXPIRES_IN,
    },
  );

  return res.status(200).json({
    accessToken,
    userId: user.id,
  });
});

app.get('/profile', authenticateToken, (req, res) => {
  res.json({
    message: 'JWT authentication successful.',
    user: req.user,
  });
});

app.get('/cards', authenticateToken, (req, res) => {
  res.json([
    {
      id: 'card_001',
      type: 'DEBIT',
      network: 'VISA',
      maskedNumber: '**** **** **** 4821',
      expiry: '08/29',
      status: 'ACTIVE',
    },
    {
      id: 'card_002',
      type: 'CREDIT',
      network: 'MASTERCARD',
      maskedNumber: '**** **** **** 7316',
      expiry: '11/28',
      status: 'ACTIVE',
    },
  ]);
});

app.listen(PORT, () => {
  console.log(`CardVault API running on http://localhost:${PORT}`);
});

