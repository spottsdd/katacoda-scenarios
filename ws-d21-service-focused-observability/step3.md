As mentioned before, our code has already been set up with Datadog APM instrumentation. 

Depending on which programming language your application is written, you may have a different process for instrumenting your code. It's always best to look at the [documentation](https://docs.datadoghq.com/tracing/setup/) for your specific language.

In our case, our applications run on [Ruby on Rails](https://docs.datadoghq.com/tracing/setup_overview/setup/ruby/#quickstart-for-rails-applications) and Python's [Flask](https://ddtrace.readthedocs.io/en/stable/integrations.html#flask). 

We'll instrument each language differently.

## Installing the Ruby APM Language Library

The `store-frontend` service has a Rails framework. The first step for instrumentation is to install the required Ruby tracing and log libraries. Next, an initializer file is added to enable Rails instrumentation, followed by a configuration file to ship logs to Datadog in JSON format so that Datadog can filter the logs based on special parameters. Finally, the docker-compose file is updated for trace and log collection and App Analytics for the frontend service.

The store-frontend service has been instrumented for you. Let's review the instrumentation.

Open the IDE tab. Take a look at `Gemfile`{{open}} in the Katacoda file explorer.

**Line 46** installs the `ddtrace` Gem, which is [Datadog’s tracing client for Ruby](https://docs.datadoghq.com/tracing/setup/ruby/). The `ddtrace` library traces requests as they flow across web servers, databases, and microservices so that developers have high visibility into bottlenecks and troublesome requests.

**Line 49** installs the `rails_semantic_logger` Gem, which is a feature rich replacement for the Ruby and Rails loggers. To learn more, view the [rails_semantic_logger](https://logger.rocketjob.io/) documentation.

To enable the Rails instrumentation, an initializer file was created in the config/initializers folder. Open the file `datadog.rb`{{open}}.

There, we control a few settings:

```ruby
Datadog.configure do |c|
  # This will activate auto-instrumentation for Rails
  c.use :rails, {'service_name': 'store-frontend', 'cache_service': 'store-frontend-cache', 'database_service': 'store-frontend-sqlite'}
  # Make sure requests are also instrumented
  c.use :http, {'service_name': 'store-frontend'}
end
```

## Additional Settings

Open the IDE tab, and then open the `docker-compose.yml`{{open}} file.

By default, the Datadog Ruby APM trace library will send traces to `localhost` over port 8126. Because we're running within `docker-compose`, we needed to set an environment variable, `DD_AGENT_HOST`, for our Ruby trace library to know to ship to the `agent` container instead. You'll find this on **line 57**.

We've also added `DD_TRACE_SAMPLE_RATE` and set it to be `1`. This allows us to use [Tracing without Limits™](https://docs.datadoghq.com/tracing/trace_retention_and_ingestion/) for Trace Search and Analytics from within Datadog. We're also able to continue traces downstream, utilizing Distributed Traces.

With this, our Ruby application is instrumented. 

Next, let's look at how a Python application is instrumented.