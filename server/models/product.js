const mongoose = require('mongoose');
const ratingSchema = require('../models/rating');
const productSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true,
    },
    images: {
        type: [{
            type: String,
            required: true,
        }],
    },
    quantity: {
        type: Number,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    //rating
    ratings: [ratingSchema],

});

//to create a model
const Product = mongoose.model('Product', productSchema);
module.exports = Product;