const express = require('express');
const bcrypt = require('bcryptjs');

const User = require('../models/user');



// with this we have access of express router and route can be like in the sense nested easily no need to write or hardcore from beginning of the api route
const authRouter = express.Router();

authRouter.post('/api/signup', async(req, res) => {

    try {
        const { name, email, password } = req.body;

        //can not be same email --> create our own model
        const existingUser = await User.findOne({
            email: email // or just email
        });

        if (existingUser) {
            return res.status(400).json({
                message: "User with same email already exists!",
            });
        }

        //salt
        const salt = bcrypt.genSaltSync(10);

        //hash
        const hashedPassword = bcrypt.hashSync(password, salt);
        // console.log(password);
        // console.log(hashedPassword);

        // to check the hashedPassword and user's password is same 
        // console.log(await bcrypt.compare(password, hashedPassword));

        //creating new user model and saving it
        let user = new User({
            email,
            password: hashedPassword,
            name,
        });
        user = await user.save(); // only the data wll be saved to database
        res.json(user); // by default status code will be 200

        //More two field by default
        // -v --> version of file
        //object id 
    } catch (e) {
        res.status(500).json({
            error: e.message,
        });
    }
});

module.exports = authRouter;