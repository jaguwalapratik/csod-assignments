aws events remove-targets --rule MonitorWebsites --ids 1
aws events delete-rule --name MonitorWebsites

aws lambda delete-function --function-name ScheduledLambdaForMonitoring
aws lambda delete-function --function-name WebsiteMonitor
aws lambda delete-function --function-name SetupTableWithDummyRecords