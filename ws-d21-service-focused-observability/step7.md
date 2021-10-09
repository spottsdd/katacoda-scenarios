As we've already seen, on the Service Overview, we can see at a glance endpoints that are running slower than the rest.

Now that we've reduced the response time on our `/ads` requests, let's see if we can fix one more problematic endpoint.

Let's look at the Store-Frontend service's `HomeController#index` again. The `advertisements-service` is no longer taking up so much time, but we see another service is still taking up a lot of time during the trace.

![Flame Graph](./assets/store-frontend_flame-graph_discounts-service.png)

Jump to the Resource page by clicking on the `flask.request GET /discount` span. Above the Tags click the kebab menu icon to directly access the Resource page.

![Kebab Menu](./assets/kebab-menu.png)

Look over the Span Summary page. Is there a specific span that's occurring much more often than the others? Maybe something with a higher Average Spans per trace?

It looks like we've got a classic N+1 query on our `discounts-service`. From the Trace Flame Graph, there appears to be a *lot* of trips to the database for each request. We can likely improve this performance by reducing these multiple trips to the database.

Open the source code file: `discounts-service/discounts.py`{{open}} and locate the `flask_request.method == 'GET'` section. There will be a line of code which states what happened, with a fix. Uncomment the suggested changes right under the view definition, and comment out line 29.

With this, we've now made a great first attempt at improving the experience for our users. Let's update the `DD_VERSION` number in `/deploy/docker-compose/docker-compose-broken-instrumented.yml`{{open}} to `1.1` for the `discounts` service.

Restart the service using  `ctrl + C`.

Next run:
`POSTGRES_USER=postgres POSTGRES_PASSWORD=postgres  docker-compose -f docker-compose-broken-instrumented.yml up`{{execute}}

With this, we can now spin back up our application, and see the difference in traces between our previous and current improvements.

## Adding Monitors to Our Services

Navigate to the [Datadog Services list](https://app.datadoghq.com/apm/services) page. When we hover over each of the services, we see *View Suggested* under the *Monitors* column. These are built-in monitors that can be quickly and easily created for our services. Monitors can oversee different aspects of our services to ensure we have visibility into our application, even when we are not looking. We can configure a monitor and allow it to observe our application, sending alerts to various channels when it's triggered.

![Suggested Monitors](./assets/suggest-monitors.png)

Let's add one of these monitors so we can tell when our applications latency has risen too high, ensuring we are quickly alerted and are able to fix the issue.

In this case, we are going to enable the default suggested `P90` latency monitor to the `store-frontend`, so we can tell when things are taking too long to respond.