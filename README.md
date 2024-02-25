<h1
    align = "center"
    style = "color:FireBrick">
    QA Analyst
</h1>

<p
    align = "center">
   <b> Hi everyone!</b>
</p>

<b>Table of contents:</b>
* [All user activity by id](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#all-user-activity-by-id)
* [Count users by AB-group](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#count-users-by-ab-group)
* [User activity by ads](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#user-activity-by-ads)
* [Users ANR by ads](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-anr-by-ads)
* [Users activity by ad network used](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-activity-by-ad-network-used)
* [Count networks activity](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#count-networks-activity)
* [Users states by social ID](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-states-by-social-id) 
* [Users states by any step](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-states-by-any-step)
  
___

Hello, I already said somewhere that I like to develop in the direction of analytics (_there is something incredible about it_) and this repository reflects the main typed requests that I use almost every day. In fact, there are many more of them, but I think these are the templates that cover the overwhelming amount of testing.

In the first, I'll tell you a little about the DBMS. My experience is based on the work of ClickHouse, which is described by the OLAP (_On-Line Analytical Processing_) model. This model is denormalized and focuses on the speed of sampling and financial analytical calculations. Responses to SQL-request take the format of a columnar data structure.

><p style = "color:SteelBlue"><u><b>General info:</b></u></p>
><p>• ClickHouse;</p>
><p>• OLAP;</p>
><p>• Columnnar.</p>

><u><b>I also want to warn you that any of the data listed below does not in any way reflect current or ever past expenses of any company!</b></u>

<p
    align = "center"
    style = "color:FireBrick">
    <b>Let's get started!</b>
</p>

## [All user activity by id](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/user_all_events.sql)
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
The output from this request will look something like this:
created_at | activity_kind| event_name | ab_group | base_parameters
------------ | ------------- | ------------- | ------------- | -------------
2024-02-23 11:30:58 | event| GameExit | Testing | {total_time; win_score; ...}
2024-02-23 11:29:56 | event| CoreOpen | Testing | {total_time; win_score; ...}
2024-02-23 11:29:41 | event| PreferencesSelected | Testing | {total_time; win_score; ...}
2024-02-23 11:07:06 | event| RegimeChanged | Testing | {total_time; win_score; ...}
2024-02-23 11:07:02 | event| SessionStart| Testing | {total_time; win_score; ...}
2024-02-23 11:05:58 | install| | | 
etc | etc| etc| etc| etc

Pay attention to the line with `activity_kind = 'install'`. This kind of activity is controlled by the device environment, not the environment of our product, so the fields `event_name`,`ab_group` and `base_parameters` are empty. It will most likely be the same with `activity_kind = 'session'`. You can easily filter the request by removing such empty bars. You need to add a condition:
```SQL
AND activity_kind <> ('install','session')
```

## [Count users by AB-group](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/users_count_by_ab.sql)
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
The output from this request will look something like this:
app_version | ab_group | users_unique
------------ | ------------- |  ------------- |
1.74 | 021_AbName_Testing | 2751
1.74 | 021_AbName_Control | 2748

One of the reasons I track data like this is to ensure that users are correctly assigned to groups. In this case, the distribution of users has a 1:1 ratio, as you may have already noticed. If this was planned at the development stage, then the <u>__expected result = the actual result__</u>.

## [User activity by ads](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/user_activity_by_ad_views.sql)
Due to the fact that the vast majority of my experience is tied to mobile game development, advertising monetization and everything connected with it plays a rather important role. Including advertising monetization analytics. Consider a request to search for the activity of a specific user (_tester_):
```SQL
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
```
The output from this request will look something like this:
created_at | ad_type | ad_placement | ad_status |  base_parameters | 
------------ | ------------- |  ------------- |  ------------- |  ------------- |
2024-01-21 17:54:32 | Banner | Core | End | {total_time; wins_score; ...} |
2024-01-23 15:25:52 | Rewarded | Shop | Fail | {total_time; wins_score; ...} | 
2024-01-23 15:23:43 | Rewarded | Shop | Complete | {total_time; wins_score; ...} | 
2024-01-23 15:20:04 | Rewarded | Shop | Complete | {total_time; wins_score; ...} | 
2024-01-22 16:04:17 | Interstitial | CoreExit | Complete | {total_time; wins_score; ...} | 
2024-01-22 16:04:14 | Interstitial | CoreExit | Click | {total_time; wins_score; ...} | 
2024-01-22 16:04:13 | Interstitial | CoreExit | Click | {total_time; wins_score; ...} | 
2024-01-22 16:03:44 | Interstitial | CoreExit | Start | {total_time; wins_score; ...} | 
2024-01-22 15:01:51 | Banner | Core | Start | {total_time; wins_score; ...} | 
2024-01-21 17:54:32 | Banner | Core | Start | {total_time; wins_score; ...} | 
etc | etc | etc | etc | etc | 

The data must correspond to my actions performed on the device being tested for the corresponding test-cases for advertising monetization. In this case, the logging compliance is checked the compliance with the time of event creation, the type of advertising, its placement and status is checked.

## [Users ANR by ads](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/users_anr_by_ad_views.sql)
As you may have noticed from the data in the chapter above, one of the results of viewing an advertisement `ad_status = Fail`. During the post-release process and for further sampling of restrictions on certain advertising placements, it is useful to understand how often viewing an advertisement leads to application crashes. Similar analyzes can be carried out using the following request:
```SQL
SELECT	JSONExtractString(base_parameters,'status') AS ad_status,
	COUNT(ad_status) AS count
FROM AdjustData.RealTimeAnalytics
WHERE toDate(created_at) >= '2024-02-02'
AND event_name = 'AdView'
AND ad_status IN ('Fail', 'Complete', 'Start')
AND app_name = 'ProjectName'
GROUP BY ad_status
ORDER BY count DESC
```
The output from this request will look something like this:
ad_status | count |
------------ | ------------- |
Start | 4293 |
Complete | 4064 |
Fail | 3 |

You can visualize the result as a diagram (_in most cases, this is supported by database frameworks_).
![UsersAnrByAds](https://github.com/msgrigorovich/SQL/blob/main/README_PICTURES/UsersAnrByAds.jpg?raw=true)
Based on the response data, you can see that the amount of similar cases is quite small. Which helps to prioritize potential bugs, even the next advertising placement that has not yet been implemented.

## [Users activity by ad network used](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/user_activity_by_network_ad_views.sql)
Ad monetization is one of the most unstable areas of testing that I have encountered. Sometimes, when testing a particular advertising network, the advertising debugger generated an error, but is it relevant in production? If there was no update compared to the PROD version in the test, you can use user analytics, which will most likely answer this question. This can be done using the following request with Google AdMob Network:
```SQL
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
```
The output from this request will look something like this:
app_name | created_at | store | ad_network | ad_placement | ad_type |
------------ | ------------- | ------------- | ------------- | ------------- | ------------- |
com.CompanyName.ProjectName |2024-01-19 16:16:02 | google | Google AdMob | CoreExit | Interstitial |
com.CompanyName.ProjectName |2024-01-19 17:15:44 | itunes | Google AdMob | CoreExit | Interstitial |
com.CompanyName.ProjectName |2024-01-19 17:15:42 | itunes | Google AdMob | Shop | Rewarded |
com.CompanyName.ProjectName |2024-01-19 17:14:37 | google | Google AdMob | Core | Banner |
etc | etc | etc | etc | etc | etc |

User data convinces that the Google AdMob Network and is supported by advertising placements of our product.

## [Count networks activity](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/count_networks_activity.sql)
If you need to verify the stability of networks at the aggregate level, you can use the following request, which will return all networks built into the product:
```SQL
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
```
The output from this request will look something like this:
networks | impressions |
------------ | ------------- |
AppLovin | 1307 |
ironSource | 362 |
Unity Ads | 294 |
Mintegral | 260 |
Facebook | 192 |
InMobi | 159 |
DT Exchange | 137 |
etc | etc |

You can visualize the result as a diagram (_in most cases, this is supported by database frameworks_)
![CountNetworksActivity](https://github.com/msgrigorovich/SQL/blob/main/README_PICTURES/CountNetworksActivity.jpg?raw=true)

Now we can not only see the quantitative assessment, but also imagine which of the networks enjoys a higher rate.

## [Users states by social ID](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/user_states_by_social.sql)
I would also like to touch on one more type of request that is used quite often. Next we will talk about requests for custom saves. We can access and perform almost any manipulation on any user's saves if necessary (_and providing the project's architecture_). For example, the request below returns the user’s saves through some social network:
```SQL
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
```
The output from this request will look something like this:

created_at | event_name | reason | social_network | base_parameters |
------------ | ------------- |------------ | ------------- |------------ |
2024-01-24 16:16:02 | SocialConnected | MainMenu | Google | {total_time; wins_score; ...} |
2024-01-21 16:16:02 | SocialConnected | SettingsMenu | Google | {total_time; wins_score; ...} |
2024-01-18 16:16:02 | SocialConnected | SettingsMenu | Apple | {total_time; wins_score; ...} |
2024-01-06 16:16:02 | SocialConnected | MainMenu | Google | {total_time; wins_score; ...} |
2024-01-02 16:16:02 | SocialConnected | MainMenu | Facebook | {total_time; wins_score; ...} |
etc | etc | etc | etc | etc |

In this case, when the user decides to save his progress through a social network, a unique identifier is created, which becomes the primary and highest priority user ID. The fact is that gaining access to IDFA is questionable and depends on the user’s decision. And even if the user agrees to IDFA tracking, this is still not considered an absolutely safe option, because the user always has the opportunity to reset/disable IDFA through the system settings of the device. Which leads to the generation of a user ID, but valid only within our project. Generating such an ID is considered unstable, because if our application is reinstalled, this ID will be generated anew and the user will lose his progress. Thus, the most reliable way to store your saves is through social networks.

In my work, quite often I come across users who have lost their progress in this way. However, if he contacted the developer, then we always have the opportunity to pull out this save and install it again. This is done in a matter of minutes.

## [Users states by any step](https://github.com/msgrigorovich/SQL/blob/main/SQL-Requests/user_states.sql)
Saving your data using your social network ID is truly reliable. But what if the user mixed up the social network and restored the wrong saves? The request below allows you to track the change in user saves with each action in our application:
```SQL
SELECT	bundle_id,
    	app_version,
 	event_time,
 	process,
  	login,
	if	(notEmpty((JSONExtractString(request,'state')) AS state_request),
		(JSONExtractString(request  ,'state')) AS state_request,
		(JSONExtractString(response ,'state')) AS state_response) AS state_encode
FROM UsersStates -- exmaple TableName
WHERE user_id = 'FC8BF1B5-8083-41D6-A6C9-2D3D8C859565' -- user_id_example
AND toDate(event_time) >= '2024-01-01'
AND bundle_id = 'com.CompanyName.ProjectName'
ORDER BY event_time DESC
```
The output from this request will look something like this:
bundle_id | app_version | event_time | process | login | state_encode |
------------ | ------------- |------------ | ------------- | ------------- |------------ |
com.CompanyName.ProjectName | 1.74 | 2024-01-25 16:13:31 | LOAD | 145807315230377 | {FirstLaunchVersion: 1.74; ...} |
com.CompanyName.ProjectName | 1.74 | 2024-01-25 16:13:28 | SAVE | 145807315230377 | {FirstLaunchVersion: 1.74; ...} |
com.CompanyName.ProjectName | 1.74 | 2024-01-25 16:13:27 | RESOLVE | 145807315230377 | {FirstLaunchVersion: 1.74; ...} |
com.CompanyName.ProjectName | 1.74 | 2024-01-25 16:13:03 | LOAD |  | {FirstLaunchVersion: 1.23; ...} |
com.CompanyName.ProjectName | 1.74 | 2024-01-25 16:12:52 | LOAD |  | {FirstLaunchVersion: 1.23; ...} |
etc | etc | etc | etc | etc | etc |

From the output data we can notice that the user replaced his state with the starting version 1.23 with a state with the starting version 1.74. It’s easy to take the state before replacement and pass it on to the user just as before.

In fact, as mentioned above, we can track the user’s saving at any step he takes. Therefore, a user, for example, may accidentally spend some currency and ask us to roll back this change. There may be a lot of options, but not all of them are worthy of attention.

I would also like to note that I did not say above, the user’s state is most often issued encrypted (_that’s why the field is called `state_encode`_). This is done from the point of view of optimizing data storage and security. In the example table with the output data, I did not encrypt them, just for clarity. But if they are encrypted, then you need to use the `decrypt`-function (_depending on what DBMS you have_), or any online decoder.

___

<b>Table of contents:</b>
* [All user activity by id](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#all-user-activity-by-id)
* [Count users by AB-group](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#count-users-by-ab-group)
* [User activity by ads](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#user-activity-by-ads)
* [Users ANR by ads](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-anr-by-ads)
* [Users activity by ad network used](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-activity-by-ad-network-used)
* [Count networks activity](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#count-networks-activity)
* [Users states by social ID](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-states-by-social-id) 
* [Users states by any step](https://github.com/msgrigorovich/SQL/tree/main?tab=readme-ov-file#users-states-by-any-step)

___

<p
    align = "center">
    I hope this material was informative and interesting. I was very happy to share my skills with you!
</p>
<p
    align = "center">
    <b>Best regards, Diana Grigorovich!</b>
</p>
<h1
    align = "center"
    style = "color:FireBrick">
    Thanks for your attention!
</h1>
