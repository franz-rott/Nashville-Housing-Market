/*

Cleaning Data in SQL Queries

*/


Select 
	*
From 
	SQL_project_housing.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
Select 
	SaleDate, 
	CONVERT(Date,SaleDate)
From 
	SQL_project_housing.dbo.NashvilleHousing


Update 
	NashvilleHousing
SET 
	SaleDate = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select 
	*
From 
	SQL_project_housing.dbo.NashvilleHousing
Where 
	PropertyAddress is null
ORDER BY
	ParcelID



Select 
	a.ParcelID, 
	a.PropertyAddress, 
	b.ParcelID, 
	b.PropertyAddress, 
	ISNULL(a.PropertyAddress,b.PropertyAddress)
From 
	SQL_project_housing.dbo.NashvilleHousing a
JOIN 
	SQL_project_housing.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where 
	a.PropertyAddress is null


Update 
	a
SET 
	PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From 
	SQL_project_housing.dbo.NashvilleHousing a
JOIN 
	SQL_project_housing.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where 
	a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From SQL_project_housing.dbo.NashvilleHousing
Where PropertyAddress is null
--order by ParcelID

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as StreetAddress,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) as City
FROM 
    SQL_project_housing.dbo.NashvilleHousing
WHERE 
    PropertyAddress IS NOT NULL
    AND PropertyAddress LIKE '%,%'





ALTER TABLE	
	NashvilleHousing
Add 
	PropertySplitAddress Nvarchar(255);

Update 
	NashvilleHousing
SET 
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
WHERE 
    PropertyAddress IS NOT NULL
    AND PropertyAddress LIKE '%,%'


ALTER TABLE 
	NashvilleHousing
Add 
	PropertySplitCity Nvarchar(255);

Update 
	NashvilleHousing
SET 
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))
WHERE 
    PropertyAddress IS NOT NULL
    AND PropertyAddress LIKE '%,%'



Select 
	*
From 
	SQL_project_housing.dbo.NashvilleHousing





Select 
	OwnerAddress
From 
	SQL_project_housing.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From SQL_project_housing.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From SQL_project_housing.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change 0 and 1 to No and Yes in "Sold as Vacant" field


Select Distinct
	(SoldAsVacant), 
	Count(SoldAsVacant)
From 
	SQL_project_housing.dbo.NashvilleHousing
Group by 
	SoldAsVacant
order by 
	2




SELECT
    SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 1 THEN 'Yes'
        WHEN SoldAsVacant = 0 THEN 'No'
        ELSE CAST(SoldAsVacant AS VARCHAR(10))
    END AS SoldAsVacantFormatted
FROM 
    SQL_project_housing.dbo.NashvilleHousing
ORDER BY 
	SoldAsVacantFormatted



Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From SQL_project_housing.dbo.NashvilleHousing
--order by ParcelID
)
DELETE
--SELECT *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From SQL_project_housing.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From SQL_project_housing.dbo.NashvilleHousing


ALTER TABLE SQL_project_housing.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



