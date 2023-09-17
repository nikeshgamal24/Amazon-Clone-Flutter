const jwt = require("jsonwebtoken");

const auth = async(req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        console.log('inside auth middle ware')
        console.log(`token ${token}`);

        if (!token) {
            return res.status(401).json({
                message: "No auth token, access denied",
            });
        }

        const verified = jwt.verify(token, "passwordKey");
        if (!verified) return res.status(401).json({
            message: "Token verification failed, authorization denied",
        })

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
module.exports = auth;