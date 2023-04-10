const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB();
const ses = new AWS.SES();

exports.handler = async(event) => {
    try {
      const params = {
        TableName: 'Products',
        ProjectionExpression: 'id, remain',
      };

      const data = await dynamodb.scan(params).promise();
      const productIds = data.Items.map(item => ({id: item.id.N, remain: item.remain.N,}));
      const emailParams = {
        Destination: {
          ToAddresses: ['rlawlgnswns@naver.com']
        },
        Message: {
          Body: {
            Text: {
              Data: `항목별 남은 재고 상황: ${productIds.map((product) => `${product.id}: ${product.remain}`).join(', ')}.`,
            }
          },
          Subject: {
            Data: '항목별 재고 수량 알림'
          }
        },
        Source: 'rlawlgnswns@naver.com'
      };
      
      if (productIds.length > 0) {
        await ses.sendEmail(emailParams).promise();
      }
    
      return {
        statusCode: 200,
        body: JSON.stringify('재고 수량 확인 완료')
      };
    } catch (err) {
      console.log(err);
      return {
        statusCode: 500,
        body: JSON.stringify('Error checking stock')
      };
    }
};
