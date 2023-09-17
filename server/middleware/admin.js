const jwt = require('jsonwebtoken');
const User = require('../models/user');
const admin = async(req, res, next) => {
    const token = req.header('x-auth-token');
    try {

        console.log("=======================================");
        console.log("Inside admin middle");
        console.log(`token: ${token}`);

        if (!token) {
            return res.status(401).json({
                message: "No auth token, access denied",
            });
        }

        const verified = jwt.verify(token, "passwordKey");
        console.log("=======================================");
        console.log(`verified status: ${verified}`);
        if (!verified) return res.status(401).json({
            message: "Token verification failed, authorization denied",
        })

        const user = await User.findById(verified.id);
        console.log("=======================================");
        console.log(`user:`);
        console.log(user);
        if (user.type == 'user' || user.type == 'seller') {
            return res.status(401).json({
                msg: "You are not an admin!",
            })
        }

        req.user = verified.id;
        req.token = token;
        // console.log(`req.user:${req.user}`);
        // console.log(`req.token:${req.token}`);
        next(); //call next callback function

    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
}

module.exports = admin;