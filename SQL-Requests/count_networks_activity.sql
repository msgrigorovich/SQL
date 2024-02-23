SELECT	ad_network AS networks,
		--uniqExact(ad_network),
		COUNT(ad_network) AS impressions
FROM AdjustData.TableViewExample -- database_and_tableview_example
WHERE app_name = 'com.CompanyName.ProjectName'
AND toDate(created_at) >= '2024-02-15'
AND activity_kind = 'ad_revenue'
AND networks <> ''
--AND os_name = 'android'
GROUP BY ad_revenue_network
ORDER BY impressions DESC