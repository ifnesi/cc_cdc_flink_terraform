import os
import json


# Parse AWS TF Vars file
tf_vars_filename = os.path.join("..", "tf_aws_data.json")
with open(tf_vars_filename, "r") as f:
    tf_vars = json.loads(f.read())

user = tf_vars["default"]["value"]["username"]
password = tf_vars["default"]["value"]["password"]
dsn = f"""{tf_vars["default"]["value"]["address"]}/orcl"""
port = int(tf_vars["default"]["value"]["port"])
