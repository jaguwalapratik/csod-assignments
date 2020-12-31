import boto3
from urllib.request import urlopen

def record_metric(value, metric):
    d = boto3.client('cloudwatch')
    d.put_metric_data(Namespace = 'Website Status',
        MetricData=[{
            'MetricName': metric,
            'Dimensions': [
                {
                    'Name': 'Status',
                    'Value': 'WebsiteStatusCode',
                }],
            'Value': value,
        }]
    )
    
def do_health_check(url, metric):
    STAT = 1
    print("Checking %s " % url)
    
    try:
        response = urlopen(url)
        response.close()
    except urllib2.URLError as e:
        if hasattr(e, 'code'):
            print("[Error:] Connection to %s failed with code: " %url +str(e.code))
            STAT=100
            record_metric(STAT, metric)
        if hasattr(e, 'reason'):
            print("[Error:] Connection to %s failed with code: " %url +str(e.reason))
            STAT=100
            record_metric(STAT, metric)
    except urllib2.HTTPError as e:
        if hasattr(e, 'code'):
            print("[Error:] Connection to %s failed with code: " %url +str(e.code))
            STAT=100
            record_metric(STAT, metric)
        if hasattr(e, 'reason'):
            print("[Error:] Connection to %s failed with code: " %url +str(e.reason))
            STAT=100
            record_metric(STAT, metric)
        print('HTTPError!!!')
        
    if STAT != 100:
        STAT = response.getcode()
        
    return STAT
            
def handler(event, context):
    site_url = event['url']
    
    metricname = 'Site Availability'
    
    r = do_health_check(site_url, metricname)
    if r == 200 or r == 304:
        print("Site %s is up" %site_url)
        record_metric(200, metricname)
    else:
        print("[Error:] Site %s down" %site_url)
        record_metric(50, metricname)
            
    return r