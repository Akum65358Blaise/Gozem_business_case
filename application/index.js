const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const taskRoutes = require('./routes/tasks');
const app = express();

app.use(bodyParser.json());

mongoose.connect('mongodb+srv://snoopdangote:UykbqunbJXfA0Hlc@g1-cluster.gxyak3d.mongodb.net', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});


app.use('/tasks', taskRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
