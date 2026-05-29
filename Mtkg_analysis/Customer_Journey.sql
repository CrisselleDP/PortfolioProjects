SELECT *
  FROM dbo.customer_journey

-- to identify and tag duplicate records


WITH DuplicateRecords AS (
	Select * ,
	ROW_NUMBER() OVER (
		PARTITION BY 
		CustomerID,ProductID,VisitDate,Stage, Action
	ORDER BY JourneyID ) row_num
	From dbo.customer_journey)

SELECT *
FROM DuplicateRecords
WHERE row_num > 1
ORDER BY JourneyID


-- Subquery to fill in Null values and change Case for Stage column

Select 
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	COALESCE(Duration, avg_duration) Duration
From 
	(Select
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	UPPER(Stage) AS Stage,
	Action,
	duration, 
	AVG(duration) OVER (PARTITION BY VisitDate) AS avg_duration ,
	ROW_NUMBER() OVER (
		PARTITION BY 
		CustomerID,ProductID,VisitDate,UPPER(Stage), Action
	ORDER BY JourneyID ) row_num
	FROM dbo.customer_journey) 
	AS subquery
WHERE row_num = 1
	
