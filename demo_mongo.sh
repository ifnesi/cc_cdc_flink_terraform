#!/bin/bash

function tf_enable() {
    if [ -f "$1.disabled" ]; then
        mv $1.disabled $1
    fi
}

source ./demo_vars

if [[ $(< $STATUS) != "1" ]]; then
    echo
    echo "ERROR: You need to run ./demo_start.sh"
    echo

else
    source $FILE
    
    # Create MongoDB resources
    tf_enable mongodb.tf
    terraform plan
    terraform apply --auto-approve
    terraform output -json > tf_mongo_data.json
fi
