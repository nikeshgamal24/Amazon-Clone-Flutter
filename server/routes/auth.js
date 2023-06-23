const express = require("express");
const bcrypt = require("bcryptjs");

const User = require("../models/user");
const auth = require("../middleware/auth");

// with this we have access of express router and route can be like in the sense nested easily no need to write or hardcore from beginning of the api route
const authRouter = express.Router();

const jwt = require("jsonwebtoken");

//SIGNUP ROUTE
authRouter.post("/api/signup", async(req, res) => {
    try {
        console.log(req.body);
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

        // res.status(200).json({
        //     message: "Upated to database succcessfully",
        // });
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
        console.log(`email ${email} and password ${password}`);
        const user = await User.findOne({
            email, // email:email optional
        });

        if (!user) {
            return res.status(400).json({
                message: "User with this email does not exists",
            });
        }
        console.log('working till here2');

        //comparting the password and encrypted password using bcryptjs using .compare()
        const isMatch = await bcrypt.compare(password, user.password);
        console.log(isMatch);
        // console.log(`Password: ${password} and Hashed Password: ${user.password}`);
        // console.log(status);
        if (!isMatch) {
            return res.status(400).json({
                message: "Incorrect pasword",
            });
        }

        console.log('working till here3');

        //token will be created each time we sign in
        const token = jwt.sign({
                id: user._id,
            },
            "passwordKey"
        );
        console.log('working till here4');
        //we send the token and store in the app's memory
        console.log(user);
        return res.json({ token, ...user._doc });

    } catch (error) {
        return res.status(500).json({
            error: error.message,
        });
    }
});


//checking for the token // api to determine the token is valid
authRouter.post("/tokenIsValid", async(req, res) => {
    try {

        // console.log('--------------index of x-auth-token--------')
        //headder index to obtain the token
        const headerIndex = req.rawHeaders.indexOf('x-auth-token');

        const token = req.rawHeaders[headerIndex + 1];

        // console.log('inside /tokenIsValid route');
        // console.log(`token :${token}`);
        tokenStatus = (token !== (null || undefined)) ? true : false
            // console.log(tokenStatus);
        if (!token) {
            console.log('token not found')
            return res.json(false);
        }


        //we want to verify the token by using jwt.verify--> that will return the callback function and if done promisify it will be converted to the promises so for that we need to use the await that will return its value that can be stored and be checked 
        // console.log("workign till jwt verification");
        const verified = jwt.verify(token, "passwordKey");
        // console.log(verified) //passwordKey---> is a public key
        if (!verified) {
            console.log("not verified");
            return res.json(false);
        }

        //is the user is available or not i.e. random token that is happened to be rue
        const user = await User.findById(verified.id);
        // console.log(user);

        if (!user) {
            console.log(" not user");
            return res.json(false);
        }
        // console.log("working fully");
        //if all passess
        res.json(true);
    } catch (error) {
        return res.status(500).json({
            error: error.message,
        });
    }
});


//get user data 
authRouter.get('/', auth, async(req, res) => {
    console.log("inside get-->/ route ")
    console.log(req.user);
    const user = await User.findById(req.user);
    res.json({...user._doc, token: req.token });
})

module.exports = authRouter;