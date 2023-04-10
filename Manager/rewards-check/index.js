const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient();
const serverless = require('serverless-http');
const express = require('express');
const app = express();
app.use(express.json());

app.get('/rewards/:user_id', async (req, res, next) => {
   const { user_id } = req.params;

   const params = {
     TableName: 'Rewards',
     FilterExpression: 'user_id = :user_id',
     ProjectionExpression: 'id, product_id',
     ExpressionAttributeValues: {
       ':user_id': user_id
     }
   };

   try {
     const data = await docClient.scan(params).promise();
     res.status(200).json(data.Items);
   } catch (err) {
     console.error(err);
     res.status(500).json({ error: 'Failed to query rewards' });
   }
});

app.use((req, res, next) => {
   return res.status(404).json({
     error: 'Not Found'
   });
});

module.exports.handler = serverless(app);
module.exports.app = app;
