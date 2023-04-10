const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient();
const serverless = require('serverless-http');
const express = require('express');
const app = express();
app.use(express.json());

app.put('/products/:id', async (req, res, next) => {
   const { id } = req. params;
   const { action } = req. body;

   if (action !== 'increment' && action !== 'decrement') {
     return res.status(400).json({ error: 'Invalid action' });
   }

   const params = {
     TableName: 'Products',
     Key: { id },
     UpdateExpression: action === 'increment' ? 'ADD #remain :val' : 'ADD #remain :val',
     ExpressionAttributeNames: {
       '#remain': 'remain'
     },
     ExpressionAttributeValues: {
       ':val': action === 'increment' ? 1 : -1
     },
     ReturnValues: 'UPDATED_NEW'
   };

   try {
     const result = await docClient.update(params).promise();
     res.status(200).json(result.Attributes);
   } catch (err) {
     console. error(err);
     res.status(500).json({ error: 'Failed to update item' });
   }
});

app.use((req, res, next) => {
   return res.status(404).json({
     error: 'Not Found'
   });
});

module.exports.handler = serverless(app);
module.exports.app = app;
