SELECT *
  FROM dbo.customers


SELECT *
FROM dbo.geography

-- Join Customers and geography table
Select
	c.CustomerID,
	c.CustomerName,
	c.Email,
	c.Gender,
	c.Age,
	g.Country,
	g.City
From dbo.customers c
JOIN dbo.geography g
ON c.GeographyID = g.GeographyID
