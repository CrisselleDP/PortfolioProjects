SELECT *
  FROM dbo.customer_reviews

-- Remove extra space

Select ReviewID,
	CustomerID,
	ProductID,
	ReviewDate,
	Rating,
REPLACE (ReviewText, '  ',' ') AS ReviewText
From dbo.customer_reviews
