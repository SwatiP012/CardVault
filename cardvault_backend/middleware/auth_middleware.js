const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      message: 'Authentication token is required.',
    });
  }

  const parts = authHeader.split(' ');

  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({
      message: 'Invalid authorization header.',
    });
  }

  const token = parts[1];

  try {
    const secret = process.env.JWT_SECRET;

    if (!secret) {
      return res.status(500).json({
        message: 'JWT secret is not configured.',
      });
    }

    const decoded = jwt.verify(token, secret);

    req.user = decoded;

    next();
  } catch (error) {
    return res.status(401).json({
      message: 'Invalid or expired authentication token.',
    });
  }
}

module.exports = authenticateToken;