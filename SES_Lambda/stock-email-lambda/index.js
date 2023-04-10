const AWS = require('aws-sdk');
const sqs = new AWS.SQS();
const ses = new AWS.SES();
const QUEUE_URL = process.env.QUEUE_URL

exports.handler = async(event) => {
   try {

     const params = {
       QueueUrl: QUEUE_URL,
     };
     const data = await sqs.receiveMessage(params).promise();

     if (! data. Messages) {
       return {
         statusCode: 200,
         body: JSON.stringify('No messages found')
       };
     }

     const emailParams = {
       Destination: {
         ToAddresses: ['rlawlgnswns@naver.com']
       },
       Message: {
         Body: {
           Text: {
             Data: `${data.Messages.map(message => message.Body).join('\n')}`
           }
         },
         Subject: {
           Data: 'Message from SQS'
         }
       },
       Source: 'rlawlgnswns@naver.com'
     };

     await ses.sendEmail(emailParams).promise();

     const deleteParams = {
       QueueUrl: QUEUE_URL,
       Entries: data.Messages.map(message => ({
         Id: message. MessageId,
         ReceiptHandle: message. ReceiptHandle
       }))
     };
     await sqs.deleteMessageBatch(deleteParams).promise();

     return {
       statusCode: 200,
       body: JSON.stringify('Messages sent successfully')
     };
   } catch (err) {
     console. log(err);
     return {
       statusCode: 500,
       body: JSON.stringify('Error sending messages')
     };
   }
};