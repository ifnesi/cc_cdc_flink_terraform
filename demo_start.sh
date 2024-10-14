#!/bin/bash

function tf_disable() {
    if [ -f "$1" ]; then
        mv $1 $1.disabled
    fi
}

function tf_enable() {
    if [ -f "$1.disabled" ]; then
        mv $1.disabled $1
    fi
}

source ./demo_vars
echo 0 > $STATUS

if [ ! -f "$FILE" ]; then
    echo
    echo "ERROR: File '$FILE' does not exist. Please create this file (example shown below)"
    echo
    echo "------------------------------"
    cat .env_example
    echo "------------------------------"

else
    source $FILE

    # Enable Python virtual environment
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt

    # Do not yet create Mongo and CC Connector resources
    tf_disable mongodb.tf
    tf_disable cflt_connectors.tf

    # Create AWS resources
    terraform init
    terraform plan
    terraform apply --auto-approve
    terraform output -json > tf_aws_data.json

    # Prepare Oracle DB
    cd oracle
    python prepare_database.py
    cd ..

    # Create CC Connectors resources
    tf_enable cflt_connectors.tf

    # Update timestamp on credit_card AVRO schema
    TIMESTAMP_NOW=`date -u +%s000`
    jq -c . < ./schemas/credit_card.avsc | sed 's/"/\\"/g' | sed "s/9999999999/$TIMESTAMP_NOW/" > ./schemas/credit_card_timestamp.avsc

    terraform plan
    terraform apply --auto-approve
    terraform output -json > tf_cc_data.json
    echo 1 > $STATUS

    deactivate
fi
