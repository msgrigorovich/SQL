SELECT	app_name,
created_at,
store,
ad_network,
ad_placement,
ad_type
FROM AdjustData.TableViewExample -- database_and_tableview_example
WHERE app_name = 'com.CompanyName.ProjectName'
AND toDate(created_at) = today()
AND activity_kind = 'ad_revenue'
AND ad_network = 'Google AdMob' -- for example
--AND ad_revenue_network IN ('Google AdMob', 'Pangle', 'Google Ad Manager')
AND user_id = '7952a7a1-26c1-48c9-993e-74b75b4f24a9' -- user_id_example
ORDER BY created_at DESC