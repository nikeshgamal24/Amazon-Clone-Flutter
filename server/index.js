const express = require('express'); // like import in flutter
//npm run dev

const PORT = 3000;
const app = express();

//Creatin an API
//GET, PUT, POST , DELETE, UPDATE --> CRUD opertaion
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected at port ${PORT}`);
}); console.log(`Connected at port ${PORT}`);
});