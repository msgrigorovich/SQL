SELECT	app_version,
ab_group,
count (distinct user_id) AS users_unique -- user_id_example
FROM ProductData.ProjectName_product -- database_and_tableview_example
WHERE  ab_group LIKE '%021%' -- ab_group_number_example
GROUP BY app_version, ab_group
ORDER BY app_version, ab_group