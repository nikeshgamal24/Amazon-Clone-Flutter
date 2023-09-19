const mongoose = require('mongoose');
const { productSchema } = require('./product');
// const { productSchema } = require("../models/product");

const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            //how to validate
            validator: (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

                return value.match(re);
            },
            message: 'Please! Enter a valid email address',
        },
    },
    password: {
        required: true,
        type: String,
    },
    address: {
        type: String,
        default: '',
    },
    type: {
        type: String,
        default: 'user',
    },
    cart: [
        //product schema and quantity
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true,
            }
        }
    ],
});

//to create a model
const User = mongoose.model('User', userSchema);

module.exports = User;
module.exports = User;