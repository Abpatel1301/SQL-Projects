/* 
 
 data Cleaning using SQL 
 
 */

select * 
from SQLProject..NashvilleHousing

--------------------------------------------------------------------------------------

--Standardize Date Formate

select SaleDate
from SQLProject..NashvilleHousing

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

update SQLProject..NashvilleHousing
SET SaleDateConverted = convert(Date,saleDate)


-----------------------------------------------------------------------------------------

-- Property Address

select *
from SQLProject..NashvilleHousing
where PropertyAddress is NULL


select a.ParcelID, a.PropertyAddress, b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from SQLProject..NashvilleHousing a
join SQLProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from SQLProject..NashvilleHousing a
join SQLProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

-----------------------------------------------------------------------------------------------
-- Breaking out Address into individual Columns (Address, City, State )

/* For Property Address */

select  PropertyAddress
from SQLProject..NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as City 
from SQLProject..NashvilleHousing

ALTER TABLE SQLProject..NashvilleHousing
add PropertySpiltAddress Nvarchar(255),PropertySpiltCity Nvarchar(255);

update SQLProject..NashvilleHousing
SET PropertySpiltAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

update SQLProject..NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

/* For Owner Address */

select  OwnerAddress
from SQLProject..NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',','.'),3) as OwnerSplitedAddress,
PARSENAME(Replace(OwnerAddress,',','.'),2) as OwnerSplitedcity,
PARSENAME(Replace(OwnerAddress,',','.'),1)
from SQLProject..NashvilleHousing

ALTER TABLE SQLProject..NashvilleHousing
add OwnerSplitedAddress Nvarchar(255),OwnerSplitedcity Nvarchar(255), OwnerSplitedState Nvarchar(255);

update SQLProject..NashvilleHousing
SET OwnerSplitedAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

update SQLProject..NashvilleHousing
SET OwnerSplitedcity = PARSENAME(Replace(OwnerAddress,',','.'),2)

update SQLProject..NashvilleHousing
SET OwnerSplitedState = PARSENAME(Replace(OwnerAddress,',','.'),1)

-------------------------------------------------------------------------------------------------------------------------------

/* Update the SoldASVacant column properly */

select Distinct(SoldAsVacant), count(SoldAsVacant)
from SQLProject..NashvilleHousing
group by SoldAsVacant

select SoldAsVacant
, CASE when SoldAsVacant = 'Y' Then 'YES'
       when SoldAsVacant = 'N' Then 'NO'
       else SoldAsVacant
       end
from SQLProject..NashvilleHousing

update SQLProject..NashvilleHousing
SET SoldAsVacant = 
		CASE when SoldAsVacant = 'Y' Then 'YES'
			 when SoldAsVacant = 'N' Then 'NO'
			 else SoldAsVacant
			 end

-------------------------------------------------------------------------------------------------------------------------------

/* Remove Duplicate */

with RownumCTE AS(
select *, 
ROW_NUMBER() over (
	partition by 
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID) row_num

				
from SQLProject..NashvilleHousing
)

DELETE  
from RownumCTE
where row_num >1

--------------------------------------------------------------------------------------------------------------------------------

/* Drop used Column */

select *
from SQLProject..NashvilleHousing

ALTER TABLE SQLProject..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate




















-------------------------------------------------------------------------------------------------------------------













