import AppInsights from 'applicationinsights'

class PerformanceManagement {
  constructor () {
    const key = process.env.APPINSIGHTS_INSTRUMENTATIONKEY
    AppInsights.setup(key)
    AppInsights.Configuration
      .setAutoDependencyCorrelation(true)
      .setAutoCollectRequests(true)
      .setAutoCollectPerformance(true)
      .setAutoCollectExceptions(true)
      .setAutoCollectDependencies(true)
      .setAutoCollectConsole(true)
      .setUseDiskRetryCaching(true)
      .start()

    AppInsights.commonProperties = {
      environment: process.env.NODE_ENV || process.env.node_env || 'localhost'
    }
  }

  event (name, properties) {
    AppInsights.defaultClient.trackEvent({ name, properties })
  }

  trace (message) {
    AppInsights.defaultClient.trackTrace({ message })
  }

  serverStart (name, url) {
    const message = `${name} listening to ${url}`
    console.log(message)
    this.event('ServerStart', { message })
  }

  traceBotMessage (message) {
    this.trace(`BotResponse: ${message}`)
  }
}

export default PerformanceManagement
