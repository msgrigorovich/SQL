SELECT	created_at,
		JSONExtractString(base_parameters,'type') AS ad_type,
		JSONExtractString(base_parameters,'ad_placement') AS ad_placement,
		JSONExtractString(base_parameters,'status') AS ad_status,
		base_parameters -- global_events_example; used in json
FROM AdjustData.RealTimeAnalytics -- database_and_tableview_example
WHERE toDate(created_at) = today()
AND event_name = 'AdView'
AND user_id = 'EF8C20B5-6CBD-4EF3-A3A5-ADDFCA1DF335' -- user_id_example
ORDER BY created_at DESC