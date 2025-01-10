/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- Did not update probably so below made it work

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID

-- looking at data... notice duplicate parcelID's so need to populate property address of one if the parcelID is a match to remove null values

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID] -- can never repeat themselves
Where a.PropertyAddress is null
-- shows how address is missing from one of the duplicate ParcelID's. Now to fix

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID] 
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

-- cannot separate address from city without creating two new columns

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing



-- Simplier Way w/ Owner Address --

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing


-- add column names and values like above

-- 1
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

-- 2
ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

-- 3
ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change 1 and 0 to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE when SoldAsVacant = 1 THEN 'Yes'
	   when SoldAsVacant = 0 THEN 'No'
	   ELSE 'Unknown'
	   END
From PortfolioProject.dbo.NashvilleHousing


-- Must change table and column data type
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(10);

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 1 THEN 'Yes'
	   when SoldAsVacant = 0 THEN 'No'
	   ELSE 'Unknown'
	   END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Add a new column to the table
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD AcreageRounded DECIMAL(10, 2);

-- Update the new column with rounded values
UPDATE PortfolioProject.dbo.NashvilleHousing
SET AcreageRounded = ROUND(Acreage, 2);

-- Verify the results
SELECT Acreage, AcreageRounded
FROM PortfolioProject.dbo.NashvilleHousing;



-- Remove Duplicates
-- not done a lot in SQL

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 legalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
-- order by ParcelID
)

-- deletes duplicate values. 

Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress




Select *
From PortfolioProject.dbo.NashvilleHousing





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns 

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN Acreage

