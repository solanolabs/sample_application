#! /bin/bash

# Copyright (c) 2016 Solano Labs Inc. All Rights Reserved

set -x

if [ $TDDIUM_BUILD_STATUS != 'passed' ];
then
  echo "Build Failed, not uploading";
  exit 0; 
fi

# Build the gam
gem build solano.gemspec || { echo "Gem build failed"; exit 1; }

# Upload the gem and capture the link
location=`./scripts/upload_to_s3.sh ./solano*.gem` || { echo "Upload failed..."; exit 1; }
location=$(echo $location | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')

# Change the href of the gem download link
sed -i.bak "s/_placeholder_/$location/g" www/solano.html
sed -i.bak "s/_placeholder_/$location/g" www/index.html

# Swap the solano.yml for the next step
mv solano.yml solano.yml.pt1
mv solano.yml.pt2 solano.yml
