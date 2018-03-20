import PerformanceManagement from './azure/PerformanceManagement.mjs'
import CognitiveServices from 'botbuilder-cognitiveservices'

const apm = new PerformanceManagement()

const restify = require('restify')
const builder = require('botbuilder')

const port = process.env.port || process.env.PORT || 3978

// TODO: Move to Secret Management
const appId = process.env.MSFT_APP_ID
const appPassword = process.env.MSFT_APP_PASSWORD
const qnaKnowledgeBaseId = process.env.QNA_KNOWLEDGE_BASE_ID
const qnaSubscriptionId = process.env.QNA_SUBSCRIPTION_KEY
// END TODO

const server = restify.createServer()
server.listen(port, function () {
  apm.serverStart(server.name, server.url)
})

const recognizer = new CognitiveServices.QnAMakerRecognizer({
  knowledgeBaseId: qnaKnowledgeBaseId,
  subscriptionKey: qnaSubscriptionId})

const qnaDialog = new CognitiveServices.QnAMakerDialog({
  recognizers: [recognizer],
  defaultMessage: 'Sorry, I don\'t know how to answer that question, call us on 0800 555 555.',
  qnaThreshold: 0.3
})

const connector = new builder.ChatConnector({
  appId: appId,
  appPassword: appPassword
})

server.post('/api/messages', connector.listen())

const bot = new builder.UniversalBot(connector)

// TODO: move to Table Storage backend.
bot.set('storage', new builder.MemoryBotStorage())
bot.dialog('/', qnaDialog)
