import sys
import logging
import rds_config
import pymysql
import boto3
import json

client = boto3.client('lambda', 'us-west-2')

#rds settings
rds_host  = rds_config.db_host
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name
port = 3306

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, port=port, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")
def handler(event, context):
    """
    This function fetches content from MySQL RDS instance
    """
    
    with conn.cursor() as cur:
        cur.execute("select * from websites")
        for row in cur:
            inputParams = {
                "url": row[0]
            }
            response = client.invoke(
                FunctionName = "WebsiteMonitor",
                InvocationType = "RequestResponse",
                Payload = json.dumps(inputParams)
            )
        
            responseFromChild = json.load(response['Payload'])
            print("\n")
            print(responseFromChild)
    conn.commit()
