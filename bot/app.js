const restify = require('restify')
const builder = require('botbuilder')
const azure = require('botbuilder-azure');

const server = restify.createServer()
server.listen(process.env.port || process.env.PORT || 3978, function () {
  console.log(`${server.name} listening to ${server.url}`)
})

const connector = new builder.ChatConnector({
  appId: process.env.MicrosoftAppId,
  appPassword: process.env.MicrosoftAppPassword
})

server.post('/api/messages', connector.listen())

const bot = new builder.UniversalBot(connector, function (session) {
  session.send(`You said: ${session.message.text}`)
})
