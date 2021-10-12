#!/bin/bash

curl -sk https://datadoghq.dev/katacodalabtools/r?raw=true|bash

statusupdate "tools"
statuscheck "environment"

# Wait for required assets to appear in the filesystem
until  [ -f /root/dd_agent.sql ]
do
  sleep 2
done

cd /root/lab

ln -s /ecommworkshop/discounts-service/discounts.py
ln -s /ecommworkshop/ads-service/ads.py

ln -s /ecommworkshop/store-frontend-broken-instrumented/app/views/sprees/layouts/spree_application.html.erb
ln -s /ecommworkshop/store-frontend-broken-instrumented/app/views/sprees/products/show.html.erb
ln -s /ecommworkshop/store-frontend-broken-instrumented/config/initializers/datadog.rb

sed -i "s/'analytics_enabled': true, //" ./store-frontend-broken-instrumented/config/initializers/datadog.rb

mv /root/docker-compose.yml /root/lab

docker-compose up -d

statusupdate "workspace"