SELECT *
  FROM dbo.engagement_data

-- to clean and normalize engagement data table

Select 
	EngagementID,
	ContentID,
	CampaignID,
	ProductID,
UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
LEFT(ViewsClicksCombined,CHARINDEX('-',ViewsClicksCombined)-1) AS Views,
RIGHT (ViewsClicksCombined,LEN(ViewsclicksCombined)-CHARINDEX('-',ViewsClicksCombined)) AS Clicks,
	Likes,
FORMAT(EngagementDate,'dd-MM-yyyy') AS EngagementDate
From dbo.engagement_data
Where ContentType != 'NEWSLETTER'
