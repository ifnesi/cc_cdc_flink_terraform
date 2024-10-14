#!/bin/bash

function tf_enable() {
    if [ -f "$1.disabled" ]; then
        mv $1.disabled $1
    fi
}

source ./demo_vars
source $FILE

# Destroy all TF resources
terraform destroy --auto-approve
echo 0 > $STATUS

# Enable TF files (in case required)
tf_enable cflt_connectors.tf
tf_enable mongodb.tf

# Delete output JSON files
rm tf_*.json