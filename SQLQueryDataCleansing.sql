/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  -- cleansing data un SQL Queries

  select *
  from PortfolioProject.dbo.NashvilleHousing

  -- Standardize Date Format

  select Saledateconverted, convert(date, saledate)
  from PortfolioProject.dbo.NashvilleHousing

  update NashvilleHousing
  SET SaleDate = CONVERT(date, saledate)

  ALTER TABLE NashvilleHousing
  add saledateconverted date;

  update NashvilleHousing
  SET saledateconverted = convert(date, saledate)

  -- populate property address data

  select *
  from PortfolioProject.dbo.NashvilleHousing
  -- where propertyaddress is null
  order by ParcelID

  select a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a
  join PortfolioProject. dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
	  and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

  update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject. dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
	  and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 -- Breaking out address into individual columns (ADdress, city, state)

 select PropertyAddress
  from PortfolioProject.dbo.NashvilleHousing
  -- where propertyaddress is null
  -- order by ParcelID

  select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as address,
  SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as address

  FROM PortfolioProject.dbo.NashvilleHousing

  ALTER TABLE NashvilleHousing
  add PropertySplitAddress nvarchar(225);
  
  update NashvilleHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

  ALTER TABLE NashvilleHousing
  add PropertySplitAddress nvarchar(225);

  update NashvilleHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

  select *
  from PortfolioProject.dbo.NashvilleHousing

  select OwnerAddress
  from PortfolioProject.dbo.NashvilleHousing

  select 
  PARSENAME(replace(OwnerAddress, ',', '.') 1)
  from PortfolioProject.dbo.NashvilleHousing

  -- change Y and N to YES and NO in 'sold as vacant' field

  select distinct(SoldAsVacant), count(SoldasVacant)
  from PortfolioProject.dbo.NashvilleHousing
  group by SoldAsVacant
  order by 2

  select SoldAsVacant
  , case when SoldAsVacant = 'Y' then 'yes'
         when SoldAsVacant = 'N' then 'NO'
		 Else SoldAsVacant
		 end
  from PortfolioProject.dbo.NashvilleHousing

  update NashvilleHousing
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'yes'
         when SoldAsVacant = 'N' then 'NO'
		 Else SoldAsVacant
		 end

  -- Remove duplicates

  select *, 
	ROW_NUMBER() over (
	partition by parcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference,
				order by
					  UniqueID
					  ) row_num


  from PortfolioProject.dbo.NashvilleHousing
  order by ParcelID


  select *
  from PortfolioProject.dbo.NashvilleHousing

  -- delete unused columns

  select *
  from PortfolioProject.dbo.NashvilleHousing

  alter table PortfolioProject.dbo.NashvilleHousing
  drop column owneraddress, taxdistrict, propertyaddress

  alter table PortfolioProject.dbo.NashvilleHousing
  drop column saledate