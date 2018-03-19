import PerformanceManagement from './azure/PerformanceManagement.mjs'
const apm = new PerformanceManagement()

const restify = require('restify')
const builder = require('botbuilder')

const port = process.env.port || process.env.PORT || 3978

// TODO: Move to Secret Management
const appId = process.env.MicrosoftAppId
const appPassword = process.env.MicrosoftAppPassword
// END TODO

const server = restify.createServer()
server.listen(port, function () {
  apm.serverStart(server.name, server.url)
})

const connector = new builder.ChatConnector({
  appId: appId,
  appPassword: appPassword
})

server.post('/api/messages', connector.listen())

const bot = new builder.UniversalBot(connector, function (session) {
  const message = `You said: ${session.message.text}`
  apm.traceBotMessage(message)
  session.send(message)
})
