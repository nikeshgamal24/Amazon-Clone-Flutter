const express = require("express");
const bcrypt = require("bcryptjs");

const User = require("../models/user");

// with this we have access of express router and route can be like in the sense nested easily no need to write or hardcore from beginning of the api route
const authRouter = express.Router();

const jwt = require("jsonwebtoken");

//SIGNUP ROUTE
authRouter.post("/api/signup", async(req, res) => {
    try {
        const { name, email, password } = req.body;
        console.log(name, email, password);
        //can not be same email --> create our own model

        const existingUser = await User.findOne({
            email, // or just email
        });

        console.log(existingUser);

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

        // by default status code will be 200
        user = await user.save();

        res.status(200).json({
            message: "Upated to database succcessfully",
        });
        // only the data wll be saved to database
        //More two field by default
        // -v --> version of file
        //object id
    } catch (e) {
        res.status(500).json({
            error: e.message,
        });
    }
});

//SIGN IN ROUTE
authRouter.post("/api/signin", async(req, res) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({
            email, // email:email optional
        });

        if (!user) {
            res.status(400).json({
                message: "User with this email does not exists",
            });
        }

        //comparting the password and encrypted password using bcryptjs using .compare()
        const isMatch = await bcrypt.compare(password, user.password);

        // console.log(`Password: ${password} and Hashed Password: ${user.password}`);
        // console.log(status);
        if (!isMatch) {
            res.status(400).json({
                message: "Incorrect pasword",
            });
        }

        //token will be created each time we sign in
        const token = jwt.sign({
                id: user._id,
            },
            "passwordKey"
        );

        //we send the token and store in the app's memory
        console.log(user);
        res.json({ token, ...user._doc });

    } catch (error) {
        res.status(500).json({
            error: e.message,
        });
    }
});

module.exports = authRouter;