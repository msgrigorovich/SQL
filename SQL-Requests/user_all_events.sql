SELECT 	created_at,
activity_kind,
event_name,
JSONExtractString(base_parameters, 'ab_group') AS ab_group,
base_parameters -- global_events_example; used in json
FROM AdjustData.RealTimeAnalytics -- database_and_tableview_example
WHERE user_id = 'EF8C20B5-6CBD-4EF3-A3A5-ADDFCA1DF335' -- user_id_example
AND toDate(created_at) = today()
ORDER BY created_at DESC