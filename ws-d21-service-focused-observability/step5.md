The first place we can check is the Service Map, to get an idea for our current infrastructure and microservice dependencies.

![Datadog Service Map](./assets/service-map.png)

In doing so, we can tell that we've got two microservices that our frontend calls, a `discounts-service`, along with an `advertisements-service`.

If we navigate to our Service List in Datadog, we can see that our API itself isn't throwing any errors. The errors must be happening on the frontend.

![Services List](./assets/problematic-service.gif)

So let's take a look at the frontend service, and see if we can find the spot where things are breaking.

If we look into the service, we can see that it's been laid out by views. There's at least one view that seems to only give errors.

![Endpoints](./assets/store-frontend_endpoints.png)

Let's click into that view and see if a trace from that view can tell us what's going on.

![Problematic Traces](./assets/store-frontend_Spree_OrdersController-trace-errors.png)

It seems the problem happens in a template. Let's get rid of that part of the template so we can get the site back up and running while figuring out what happened. Thankfully our developers will handle this for us, but lets take a look at the work they will have to do to fix it.

![Trace Errors](./assets/trace-details-error-message.png)

Our developers can see that they'll need to open `spree_application.html.erb`{{open}} and delete the line under `<div class="container">`. It should begin with a `<br />` and end with a `</center>`.

In this case, the banner ads were meant to be put under `show.html.erb`{{open}} and `index.html.erb`{{open}}.

1. For the `index.html.erb`, under `<div data-hook="homepage_products">` our developers would add the code:

```ruby
<br /><center><a href="<%= @ads['url'] %>"><img src="data:image/png;base64,<%= @ads['base64'] %>" /></a></center>

```

1. For the `show.html.erb` at the very bottom they will add:

```ruby 
<br /><center><a href="<%= @ads['url'] %>"><img src="data:image/png;base64,<%= @ads['base64'] %>" /></a></center><br />
```

We can assume our developers have done that, and deploy the code changes with our new Docker image name, `ddtraining/storefront-fixed:latest`.

Edit the `docker-compose.yml`{{open}}, changing the `frontend` service to point to the:

```
  image: "ddtraining/storefront-fixed:latest"
```

It's also a good recommendation to update the `DD_VERSION` so that we can track performance changes across versions.

With that, we can spin up our project. Let's see if there's anything else going on. Click back over to our original terminal where our application is currently running and dumping logs and stop it with `ctrl + C`.

Next run:
`docker-compose up -d`{{execute}}

This will spin up our application using the changes made to the yaml file.


