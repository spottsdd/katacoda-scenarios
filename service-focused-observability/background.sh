#!/bin/bash
mkdir /ecommerce-observability
git clone https://github.com/DataDog/ecommerce-workshop /ecommerce-observability
cd /ecommerce-observability
# locked to specific commit on 2020-10-02
git checkout 9ce34516d9a65d6f09a6fffd5c4911a409d31e3f
git reset --hard


