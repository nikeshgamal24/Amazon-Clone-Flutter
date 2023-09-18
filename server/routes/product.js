const express = require('express');
const productRouter = express.Router();
const auth = require('../middleware/auth');
const Product = require('../models/product');

//Get all product category

//-->api/product?category=Essentials
//  For using "?"--> we use req.query.category

//-->api/product:category=Essentials
// we use req.params.category

productRouter.get("/api/products", auth, async(req, res) => {
    try {
        console.log("=============Inside product based on the category middleware==========");
        console.log(req.query.category);
        const products = await Product.find({ category: req.query.category });
        // get list of documents all the products
        res.json(products)
    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
});

//route for search product
// /api/products/search/i
productRouter.get("/api/products/search/:name", auth, async(req, res) => {
    try {
        console.log("=============Inside product based on the category middleware==========");
        console.log(req.params.name);

        const products = await Product.find({
            name: { $regex: req.params.name, $options: "i" }
        });

        // get list of documents all the products
        res.json(products)
    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
});

//post request route to rate the product.
productRouter.post("/api/rate-product", auth, async(req, res) => {
    try {
        //extract the id and rating from the user
        const { id, rating } = req.body;
        let product = await Product.findById(id);

        // console.log('======product.ratings========');
        // console.log(product.ratings);
        //add or remove the rating
        for (let i = 0; i < product.ratings.length; i++) {
            if (product.ratings[i].userId == req.user) {
                // if the user that already have rated the product again gives rating splice will remove the rating adn then outside the loop the push operation will update the rating will newly rated rating
                product.ratings.splice(i, 1);
                break;
            }
        }

        const ratingSchema = {
            userId: req.user,
            rating,
        }

        // console.log('======Before push operation========');
        // console.log(product);
        product.ratings.push(ratingSchema);
        // console.log('======After push operation========');
        // console.log(product);

        product = await product.save();
        res.json(product);
    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
});



module.exports = productRouter;
module.exports = productRouter;