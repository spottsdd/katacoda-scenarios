#!/bin/bash

curl -s https://datadoghq.dev/katacodalabtools/r?raw=true|bash

mkdir /ecommworkshop
git clone https://github.com/DataDog/ecommerce-workshop /ecommworkshop
cd ../ecommworkshop

# locked to specific commit on 2020-10-02
git checkout 9ce34516d9a65d6f09a6fffd5c4911a409d31e3f
git reset --hard

sudo sed -i '1i config.lograge.custom_options = lambda do |event|
    # Retrieves trace information for current thread
    correlation = Datadog.tracer.active_correlation

    {
      # Adds IDs as tags to log output
      :dd => {
        :trace_id => correlation.trace_id,
        :span_id => correlation.span_id
      },
      :ddsource => ["ruby"],
      :params => event.payload[:params].reject { |k| %w(controller action).include? k }
    }
  end' ../ecommworkshop/store-frontend-broken-instrumented/store-frontend/config/development.rb

statusupdate complete