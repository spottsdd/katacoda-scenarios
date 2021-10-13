Whenever working with new code, it can be daunting to understand a system and how all of its subsystems interact.

Datadog instrumentation allows us to get an immediate view into what's going on with our software systems, and begin exploring places that may need improvement.

If we open our `docker-compose.yml`{{open}} file, we can begin to understand how instrumentation is done with our application:

```
  agent:
    image: 'datadog/agent:7.31.1'
    environment:
      - DD_API_KEY
      - DD_LOGS_ENABLED=true
      - DD_PROCESS_AGENT_ENABLED=true
      - DD_DOCKER_LABELS_AS_TAGS={"my.custom.label.team":"team"}
      - DD_TAGS='env:sfo101'
      - DD_APM_NON_LOCAL_TRAFFIC=true
    ports:
      - 127.0.0.1:8126:8126/tcp
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /proc/:/host/proc/:ro
      - /sys/fs/cgroup/:/host/sys/fs/cgroup:ro
```

In the above yaml, we've added a Datadog Agent container and along with it, volumes to see the resource usage on our host. We have also added the Docker socket so we can read all of the containers running on the host.

In addition, on line 6, we added the environment variable reference `DD_API_KEY` along with enabling logs and the process Agent. Finally, on line 13, we've opened the port `8126` - where traces get sent for collection at the Agent level.

If we run the `env | grep ^DD`{{execute}} command we can see that our lab environment already has the Datadog API key injected into our scenario.

On line 10 in our yaml file, we set `DD_TAGS='env:sfo101'`. In this line, we've set an `env` tag for Datadog that allows us to filter to a specific environment, making sure we don't pollute other environments while testing.

Now that the application has been running for a while, we should see data coming into the Datadog account. Navigate to the [Logs Live Tail](https://app.datadoghq.com/logs/livetail) page to see logs flowing into your account.

In the next step, we will look at what is needed to add the Datadog APM trace library to each of our application level languages, and set environment variables to correctly configure our application.
