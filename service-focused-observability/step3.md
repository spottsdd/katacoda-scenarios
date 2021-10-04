As mentioned before, our code has already been set up with Datadog APM instrumentation. 

Depending on which programming language your application is written, you may have a different process for instrumenting your code. It's always best to look at the [documentation](https://docs.datadoghq.com/tracing/setup/) for your specific language.

In our case, our applications run on [Ruby on Rails](https://docs.datadoghq.com/tracing/setup_overview/setup/ruby/#quickstart-for-rails-applications) and Python's [Flask](https://ddtrace.readthedocs.io/en/stable/integrations.html#flask). 

We'll instrument each language differently.

## Installing the APM Language Library

For Ruby on Rails, we first added the `ddtrace` Gem to our Gemfile. Take a look at `store-frontend-broken-instrumented/Gemfile`{{open}} in the Katacoda file explorer, and notice we've added the Gem on line 46 so we can start shipping traces.

To enable the Rails instrumentation, create an initializer file in your config/initializers folder. You'll find the file in `store-frontend-broken-instrumented/config/initializers/datadog.rb`{{open}}.

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

Open the `/deploy/docker-compose/docker-compose-broken-instrumented.yml`{{open}} file.

By default, the Datadog Ruby APM trace library will ship traces to `localhost`, over port 8126. Because we're running within a `docker-compose`, we'll need to set an environment variable, `DD_AGENT_HOST`, for our Ruby trace library to know to ship to the `agent` container instead. You'll find this on line 44.

We also want to set `DD_TRACE_SAMPLE_RATE` to be `1.0`. This allows us to use [Tracing without Limits™](https://docs.datadoghq.com/tracing/trace_retention_and_ingestion/) for Trace Search and Analytics from within Datadog.

With this, our Ruby application is instrumented. We're also able to continue traces downstream, utilizing Distributed Traces.

Next, let's look at how a Python application is instrumented.