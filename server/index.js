//IMPORTS FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');

//INITIALIZATION
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://nikeshgamal:nikeshgamal123@cluster0.bjeclqb.mongodb.net/Database?retryWrites=true&w=majority";


//IMPORTS FROM OTHER FILES
//why do we need to import from other files 
//--> our entry point is index.js so if we don't then the existence will not be known of other file and program control will not pass to other file 
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');

//middleware  --> in node its all about the middle ware between the reqquest and response

//CLIENT --> middleware-->SERVER ---> CLIENT
// if we want to manipulate the information the data that is send by the some person
app.use(express.json());
app.use(authRouter); // register router --> authRouter is known to the node now
app.use(adminRouter);
app.use(productRouter);


//for the connection
// need to pass url to connect
mongoose.connect(DB).then(() => {
        console.log('Database connection successfull');
    }).catch((e) => {
        console.log(e);
    }) // this is a promise

// //connectino to mongofb compass
// mongoose.connect('mongodb://localhost:27017').then(() => {
//     console.log('Database connection successfull');
// }).catch((e) => {
//     console.log('Database connection fail');
// })

app.listen(PORT, () => {
    console.log(`Connected at port ${PORT}`)
});