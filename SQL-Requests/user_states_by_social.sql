SELECT	created_at,
	event_name,
	JSONExtractString(base_parameters,'reason') AS reason, -- sync placement
	JSONExtractString(base_parameters,'social_network') AS social_network,
	base_parameters -- global_events_example; used in json
FROM AdjustData.RealTimeAnalytics -- database_and_tableview_example
WHERE toDate(created_at) >= '2024-01-01'
AND event_name = 'SocialConnected'
AND user_id = '0a4f8c7f-cbf6-4428-9778-917e7b176fd5' -- user_id_example
ORDER BY created_at DESC