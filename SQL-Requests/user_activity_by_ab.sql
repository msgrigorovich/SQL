SELECT 	created_at,
        activity_kind,
        event_name,
        app_name,
        app_version,
        base_parameters -- global_events_example; used in json
FROM AdjustData.TableViewExample -- database_and_tableview_example
WHERE user_id <> 'EF8C20B5-6CBD-4EF3-A3A5-ADDFCA1DF335' -- user_id_example
AND toDate(created_at) >= today()
AND app_version = '1.94' -- version_example
-- AND activity_kind = 'ad_revenue'
-- AND activity_kind = 'install'
-- AND activity_kind = 'session'
AND activity_kind = 'event'
AND app_name = 'com.CompanyName.ProjectName'
ORDER BY created_at DESC
