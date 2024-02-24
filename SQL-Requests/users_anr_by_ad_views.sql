SELECT	JSONExtractString(base_parameters,'status') AS ad_status,
        COUNT(ad_status) AS count
FROM AdjustData.RealTimeAnalytics
WHERE toDate(created_at) >= '2024-02-02'
AND event_name = 'AdView'
AND ad_status IN ('Fail', 'Complete', 'Start')
AND app_name = 'ProjectName'
GROUP BY ad_status
ORDER BY count DESC
