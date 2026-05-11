-----Cleaning Data in SQL

Select *
From PortProject..NashvilleHousing


-- Standardize Date Format

Select SaleDateConverted ,Convert(date, SaleDate)
From PortProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted date

Update NashvilleHousing
SET SaleDateConverted = Convert(date, SaleDate)

--Populate Property Address data

Select PropertyAddress
From PortProject..NashvilleHousing
Where PropertyAddress is Null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortProject..NashvilleHousing a
JOIN PortProject..NashvilleHousing b
On a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null

 
Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortProject..NashvilleHousing a
JOIN PortProject..NashvilleHousing b
On a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null


-- Breaking out Address into Individual Columns (Address, City)

Select PropertyAddress
From PortProject..NashvilleHousing


Select 
	Substring (PropertyAddress,1,Charindex (',',PropertyAddress)-1) as Address,
	Substring (PropertyAddress, Charindex (',',PropertyAddress) +1, LEN(PropertyAddress))  as City
From PortProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
SET PropertySplitAddress = Substring (PropertyAddress,1,Charindex (',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing
SET PropertySplitCity = Substring (PropertyAddress, Charindex (',',PropertyAddress) +1, LEN(PropertyAddress))


Select OwnerAddress
From PortProject..NashvilleHousing


Select 
PARSENAME (REPLACE(OwnerAddress,',','.'), 3) as Address,
PARSENAME (REPLACE(OwnerAddress,',','.'), 2) as City,
PARSENAME (REPLACE(OwnerAddress,',','.'), 1) as State
From PortProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress,',','.'), 1)

Select *
From PortProject..NashvilleHousing


-- Change 1(Y) and 0(N) to Yes and No in "Sold

Select SoldAsVacant,
CASE When SoldAsVacant = '1' Then 'Yes' 
	 When SoldAsVacant = '0' Then 'No'
	 ELSE CAST(SoldAsVacant AS varchar(3))
	 END
From PortProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(3);

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = '1' Then 'Yes' 
	 When SoldAsVacant = '0' Then 'No'
	 ELSE CAST(SoldAsVacant AS varchar(3))
	 END

SELECT Distinct SoldAsVacant, Count (SoldAsVacant)
FROM NashvilleHousing
Group by SoldAsVacant
Order by 2


-- Remove Duplicates

Select *
From PortProject..NashvilleHousing


WITH RowNumCTE AS (
Select *,
ROW_NUMBER () OVER (
PARTITION by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER by UniqueID
			) row_num
From PortProject..NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns

Select *
From PortProject..NashvilleHousing

ALTER TABLE PortProject..NashvilleHousing
DROP COLUMN PropertyAddress,SaleDate, OwnerAddress, TaxDistrict