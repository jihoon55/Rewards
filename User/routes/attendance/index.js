'use strict'

var CUSTOMEPOCH = 1300000000000; // artificial epoch
function generateRowId(shardId) {
    const d = new Date()
    var ts = d.getTime() - CUSTOMEPOCH; // limit to recent
    var randid = Math.floor(Math.random() * 512);
    ts = (ts * 64);   // bit-shift << 6
    ts = ts + shardId;
    return (ts * 512) + randid;
}

module.exports = async function (fastify, opts) {
    fastify.get('/:user_id', async function (request, reply) {
        let data

        // Set the parameters
        const params = {
            TableName: "Attendance", //TABLE_NAME
            FilterExpression : 'user_id = :id',
            ExpressionAttributeValues : {':id' : request.params.user_id}
        };

        try {
            data = await fastify.dynamo.scan(params).promise();
        } catch (e) {
            reply.send(e)
        }


        return 'this is attendance check User ID : ' + request.params.user_id + "\n attendance : " + JSON.stringify(data)
    })

    fastify.post('/attend', async function (request, reply) {
        let data
        let day = new Date()

        // Set the parameters
        let params = {
            TableName : 'Attendance',
            Item: {
               id: generateRowId(request.body.userId),
               date: day.getTime(),
               user_id: request.body.userId
            }
        };

        await fastify.dynamo.put(params, function(err, data) {
            if (err) console.log(err);
        });

        params = {
            TableName: 'Users',
            Key: {
                id: parseInt(request.body.userId),
                username: request.body.username
            },
            UpdateExpression: 'set #a = #a + :x',
            ExpressionAttributeNames: {'#a' : 'count'},
            ExpressionAttributeValues: {
                ':x' : 1
            }
        }

        await fastify.dynamo.update(params, function(err, data) {
            if (err) console.log(err);
            else console.log(data)
        })

        return request.body.username + " 출석되었습니다!"
    })
  }
