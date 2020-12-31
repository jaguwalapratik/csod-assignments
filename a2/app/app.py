import sys
import logging
import rds_config
import pymysql
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

    item_count = 0

    with conn.cursor() as cur:
        cur.execute("drop table if exists Employee")
        cur.execute("drop table if exists websites")
        cur.execute("create table websites (url varchar(255) NOT NULL )")
        cur.execute('insert into websites (url) values("https://www.easyb2b.com")')
        cur.execute('insert into websites (url) values("https://www.google.com")')
        cur.execute('insert into websites (url) values("https://www.easyb2b.com")')
        cur.execute('insert into websites (url) values("https://www.facebook.com")')
        cur.execute('insert into websites (url) values("https://www.easyb2b.com")')
        cur.execute('insert into websites (url) values("https://www.github.com")')
        cur.execute('insert into websites (url) values("https://www.twitter.com")')
        cur.execute('insert into websites (url) values("https://www.linkedin.com")')
        cur.execute('insert into websites (url) values("https://www.easyb2b.com")')
        cur.execute('insert into websites (url) values("https://www.hackerrank.com")')
        conn.commit()
        cur.execute("select * from websites")
        for row in cur:
            item_count += 1
            logger.info(row)
            #print(row)
    conn.commit()

    return "Added %d items from RDS MySQL table" %(item_count)