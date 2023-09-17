const express = require('express');
const adminRouter = express.Router();
const admin = require('../middleware/admin');
const Product = require('../models/product');

//addding product
adminRouter.post("/admin/add-product", admin, async(req, res) => {
    try {
        console.log('-----------------------------------------------------------');
        console.log("Request body for product upload");
        console.log(req.body);
        const { name, description, images, quantity, price, category } = req.body;

        let product = new Product({
            name,
            description,
            images,
            quantity,
            price,
            category,
        });

        //now need to save to the database 
        product = await product.save();
        console.log('after saving the product details');
        console.log(product)
        res.json(product);
    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
});

module.exports = adminRouter;