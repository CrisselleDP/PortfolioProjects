SELECT *
  FROM PP_MarketingAnalytics..products


-- to categorize product price

Select ProductID, ProductName, Price,
CASE
	When Price < 50 Then 'Low'
	When Price between 50 and 200 Then 'Medium'
	Else 'High'
END AS PriceCategory
From PP_MarketingAnalytics..products

--