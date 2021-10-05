#!/bin/bash

curl -sk https://datadoghq.dev/katacodalabtools/r?raw=true|bash

mkdir /ecommworkshop
git clone https://github.com/DataDog/ecommerce-workshop /ecommworkshop
cd ../ecommworkshop
sudo sed -i "s/'analytics_enabled': true, //" ./store-frontend-broken-instrumented/config/initializers/datadog.rb
sudo sed -i '79i \ \ \ \ command: ddtrace-run flask run --port=5002 --host=0.0.0.0' ./deploy/docker-compose/docker-compose-broken-instrumented.yml
sudo sed -i '77i \ \ \ \ \ \ - DD_TRACE_SAMPLE_RATE=1.0' ./deploy/docker-compose/docker-compose-broken-instrumented.yml
sudo sed -i '48i \ \ \ \ \ \ - DD_TRACE_SAMPLE_RATE=1.0' ./deploy/docker-compose/docker-compose-broken-instrumented.yml
sudo sed -i '48i \ \ \ \ \ \ - DD_ENV=development' ./deploy/docker-compose/docker-compose-broken-instrumented.yml
sudo sed -i '59,60d' ./deploy/docker-compose/docker-compose-broken-instrumented.yml

# # locked to specific commit on 2020-10-02
# git checkout 9ce34516d9a65d6f09a6fffd5c4911a409d31e3f
# git reset --hard 

statusupdate complete