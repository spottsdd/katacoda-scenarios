# Service Focused Observability with Distributed Tracing

In this workshop, we'll apply observability principles to a partially broken eCommerce app, Storedog, deployed using Docker. The app is built using a Rails framework along with Python Flask microservices for handling coupon codes and ad services. This activity provides you with a walkthrough of the instrumentation using the following steps.

We'll first run the app, confirm that it's broken, and then review how to instrument with Datadog APM.

Next, we'll send some example traffic to it, and try to discover the parts that are broken.

Finally, we'll discover a few bottlenecks written into the source, push a fix, and confirm that it is indeed fixed.
