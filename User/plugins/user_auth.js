'use strict'

const fp = require('fastify-plugin')
const axios = require('axios')

// the use of fastify-plugin is required to be able
// to export the decorators to the outer scope

module.exports = fp(async function (fastify, opts) {
  fastify.decorate('userAuth', async function (token) {
    const {data} = await axios.get("https://t4riua3i23.execute-api.ap-northeast-2.amazonaws.com/cognito/token?id_token=" + token);
    return data
  })
})
