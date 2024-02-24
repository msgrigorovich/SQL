SELECT	bundle_id,
        app_version,
        event_time,
        process,
        login,
        if  (notEmpty((JSONExtractString(request,'state')) AS state_request),
            (JSONExtractString(request  ,'state')) AS state_request,
            (JSONExtractString(response ,'state')) AS state_response) AS state_encode
FROM UsersStates -- exmaple TableName
WHERE user_id = 'FC8BF1B5-8083-41D6-A6C9-2D3D8C859565' -- user_id_example
AND toDate(event_time) >= '2024-01-01'
AND bundle_id = 'com.CompanyName.ProjectName'
ORDER BY event_time DESC
