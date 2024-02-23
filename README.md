<h1
    align = "center"
    style = "color:FireBrick">
    QA Analyst
</h1>

Hello, I already said somewhere that I like to develop in the direction of analytics (_there is something incredible about it_) and this repository reflects the main typed queries that I use almost every day. In fact, there are many more of them, but I think these are the templates that cover the overwhelming amount of testing.

In the first, I'll tell you a little about the DBMS. My experience is based on the work of ClickHouse, which is described by the OLAP (_On-Line Analytical Processing_) model. This model is denormalized and focuses on the speed of sampling and financial analytical calculations. Responses to SQL-queries take the format of a columnar data structure.

><p style = "color:SteelBlue"><u><b>General info:</b></u></p>
><p>• ClickHouse;</p>
><p>• OLAP;</p>
><p>• Columnnar.</p>

<p
    align = "center"
    style = "color:FireBrick">
    <b>Let's get started!</b>
</p>

## [All user activity by id](https://github.com/msgrigorovich/SQL/blob/main/user_all_events.sql)
The key and most popular request is a request to display all the user’s analytical events. The request itself looks like this:
```SQL
SELECT 	created_at,
        activity_kind,
		event_name,
		JSONExtractString(base_parameters, 'ab_group') AS ab_group,
        base_parameters -- global_events_example; used in json
FROM AdjustData.RealTimeAnalytics -- database_and_tableview_example
WHERE user_id = 'EF8C20B5-6CBD-4EF3-A3A5-ADDFCA1DF335' -- user_id_example
AND toDate(created_at) = today()
ORDER BY created_at DESC
```
The output from this query will look something like this:
created_at | activity_kind| event_name | ab_group | base_parameters
------------ | ------------- | ------------- | ------------- | -------------
2024-02-23 11:30:58 | event| GameExit | Testing | {total_time; win_score; lose_score ...}
2024-02-23 11:29:56 | event| CoreOpen | Testing | {total_time; win_score; lose_score ...}
2024-02-23 11:29:41 | event| PreferencesSelected | Testing | {total_time; win_score; lose_score ...}
2024-02-23 11:07:06 | event| RegimeChanged | Testing | {total_time; win_score; lose_score ...}
2024-02-23 11:07:02 | event| SessionStart| Testing | {total_time; win_score; lose_score ...}
2024-02-23 11:05:58 | install| | | 
etc | etc| etc| etc| etc

Pay attention to the line with `activity_kind = 'install'`. This kind of activity is controlled by the device environment, not the environment of our product, so the fields `event_name`,`ab_group` and `base_parameters` are empty. It will most likely be the same with `activity_kind = 'session'`. You can easily filter the request by removing such empty bars. You need to add a condition:
```SQL
AND activity_kind <> ('install','session')
```

## [Count users by AB-group](https://github.com/msgrigorovich/SQL/blob/main/users_count_by_ab.sql)
We slightly touched AB-groups, so next I would consider a request to count the number of unique users in a particular AB-group:
```SQL
SELECT	app_version,
		ab_group,
count (distinct user_id) AS users_unique -- user_id_example
FROM ProductData.ProjectName_product -- database_and_tableview_example
WHERE  ab_group LIKE '%021%' -- ab_group_number_example
GROUP BY app_version, ab_group
ORDER BY app_version, ab_group
```
The output from this query will look something like this:
app_version | ab_group | users_unique
------------ | ------------- |  ------------- |
1.74 | 021_AbName_Testing | 2751
1.74 | 021_AbName_Control | 2748

One of the reasons I track data like this is to ensure that users are correctly assigned to groups. In this case, the distribution of users has a 1:1 ratio, as you may have already noticed. If this was planned at the development stage, then the <u>__expected result = the actual result__</u>.