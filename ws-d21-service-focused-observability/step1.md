Our legacy monolith shop uses Ruby on Rails and Spree. We've started to build out a first set of microservices, and these have been added to an initial set of containers.

We will use `docker-compose` to get our ecommerce application, Storedog, up and running. There's a prebuilt Rails Docker container image, along with the new Python / Flask microservice which will handle our Coupon codes and Ads which display in the store.

In this workshop, we're going to spin up and instrument our application to see where things are broken, and next, find a few bottlenecks.

We'll focus on thinking through what observability might make sense in a real application, and see how setting up observability works in practice.

## Log into the Datadog Trial Account

In the terminal on the right, you'll see credentials for a newly provisioned Datadog trial account. Open a new private/incognito window and use the provided credentials to log into [Datadog](https://app.datadoghq.com/account/login).

**Note:** You can access these login credentials whenever you need by typing `creds` in the terminal.
