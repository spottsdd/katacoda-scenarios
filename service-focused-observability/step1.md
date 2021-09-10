
# Storedog

Our legacy monolith shop uses Ruby on Rails and Spree. We've started to build out a first set of microservices, and these have been added to an initial set of containers.

We use `docker-compose` to get the application up and running. There's a prebuilt Rails Docker container image, along with the new Python / Flask microservice which handle our Coupon codes and Ads which display in the store.

In this workshop, we're going to start and instrument Storedog to see what things are broken, and next, find a few bottlenecks.

We'll focus on thinking through what observability might make sense in a real application, and see how setting up observability into a specific service works in practice.

Our application should be cloned from Github in this scenario, and if we change into the directory, we should be able to start the code with the following:

First run `cd /ecommworkshop/deploy/docker-compose`{{execute}}.

Next, lets actually spin up our application. `POSTGRES_USER=postgres POSTGRES_PASSWORD=postgres docker-compose -f docker-compose-broken-instrumented.yml up`{{execute}}

With the application running you should see running log output into your terminal. Now we can view our ecommerce application, Storedog, in the browser. You can either:

Click the `storedog` tab to the right, next to `Terminal`.

or 

Navigate to https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/

Try browsing around and take a look at what the shop has to offer. Notice the homepage takes a very long time to load....

![storedog](https://github.com/burningion/katacoda-tracing-datadog/raw/master/assets/ecommerce/storedog.png)

## Spinning up Traffic for Our Site

In our `/ecommworkshop/deploy/docker-compose` folder, we've got a copy of [GoReplay](https://goreplay.org) running in a Docker container.

We've also got a capture of "production" traffic using GoReplay. Let's spin up an infinite loop of that traffic. Click the "+" sign next to the `storedog` tab, and open a new terminal to spin it up:

In our new terminal window, navigate to the `docker-compose` directory of our ecommerce application with: `cd ../ecommworkshop/deploy/docker-compose`{{execute}}

To begin sending traffic to our application, we must first start our traffic container with: `docker-compose -f docker-compose-traffic-replay.yml up`{{execute}}. 

Similar to our Storedog docker-compose deployment, you should see some log output to the terminal, which should stop after a few lines. Traffic is now being sent to our app.

Now we can take a look at the first few microservices that the team has rolled out and investigate some issues we have been hearing about. Before being instrumented with Datadog, there'd been reports that the new `advertisements-service` broke the website. With the new deployment on staging, the `frontend` team is blaming the `ads-service` team, and the `advertisements-service` team is blaming the ops team...not great for overall morale.

With Datadog and APM instrumented in our code, let's see what's really been breaking our application.
