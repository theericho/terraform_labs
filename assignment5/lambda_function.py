import json
import os

def lambda_handler(event, context):
    print("Alarm Payload:")
    print(json.dumps(event))
    print(f"High CPU detected on instance: {os.environ.get('INSTANCE_ID', 'Unknown')}")

    # In a real scenario, you might send an SNS notification, scale resources, etc.
    return {
        'statusCode': 200,
        'body': json.dumps('Lambda processed the alarm event.')
    }
