const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient();

async function getAttendanceData(user_id) {
  const params = {
    TableName: 'Attendance',
    FilterExpression: 'user_id = :user_id',
    ExpressionAttributeValues: {
      ':user_id': user_id,
    },
  };

  try {
    const result = await dynamoDB.scan(params).promise();
    return result.Items;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

exports.handler = async (event) => {
  if (!event.pathParameters || !event.pathParameters.user_id) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: '유저를 찾을 수 없습니다.' }),
    };
  }

  const user_id = event.pathParameters.user_id;

  try {
    const attendanceData = await getAttendanceData(user_id);
    return {
      statusCode: 200,
      body: JSON.stringify(attendanceData),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: '출석 데이터를 가져오는 동안 오류가 발생했습니다.' }),
    };
  }
};
