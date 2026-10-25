
-- Data Cleaning on Nashville Housing Data
--    Project Objectives  --
-- Create Database and Tables then import contents
-- Populate property Address
-- Splt Property Address into Address and City
-- Do the same for Owner Address but now into Address, City and State
-- Remove Duplicates
-- Delete Unused Columns

-------------------------------------------------------------------------------------------------------------

-- Create the database
CREATE DATABASE ProjectDB

-- imported the dataset and checking the content

SELECT *
FROM [Nashville Housing Data];

-------------------------------------------------------------------------------------------------------------

-- Populating the propertyaddress

-- Step 1 (Joining the address to thierself where parcel id match same name and unique id not same
SELECT	a.UniqueID,b.UniqueID,a.ParcelID, a.PropertyAddress, 
		b.ParcelID, b.PropertyAddress, 
		ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM [Nashville Housing Data] a
JOIN [Nashville Housing Data] b 
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
ORDER BY a.ParcelID;

-- Step 2 ( Updating the table to save cchanges made to population

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing Data] a
JOIN [Nashville Housing Data] b 
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


-- Step 3 Checking Changes

SELECT *
FROM [Nashville Housing Data]
WHERE PropertyAddress IS NULL

-------------------------------------------------------------------------------------------------------------

-- Creating a new column and seperating Property Address into Address & City

-- Add new Column
ALTER TABLE [Nashville Housing Data]
ADD PropertySplitAddress VARCHAR(200),
	PropertyCity VARCHAR(200);

SELECT *
FROM [Nashville Housing Data];

-- Add Values to Column

UPDATE [Nashville Housing Data]
SET  PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) - 1),
PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress));

-------------------------------------------------------------------------------------------------------------

-- Creating a new column and seperating Owners Address into Address City & State

-- Adding 3 new columns
ALTER TABLE [Nashville Housing Data]
ADD Owners_Address NVARCHAR(255),
	Owners_Address_City NVARCHAR(255),
	Owners_Address_State NVARCHAR(255)

-- Updating the 3 columns

UPDATE [Nashville Housing Data]
SET Owners_Address_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	Owners_Address_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	Owners_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Checking the Updates
SELECT *
FROM [Nashville Housing Data]

-------------------------------------------------------------------------------------------------------------

-- Changing Y to Yes and N to No in SoldASVacant Column

-- Checking the values
SELECT DISTINCT CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant =  'N' THEN 'No'
	ELSE SoldAsVacant
	END AS Sold_As_Vacant, COUNT(SoldAsVacant) AS Count_of_Values, LEN(CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant =  'N' THEN 'No'
	ELSE SoldAsVacant
	END)
FROM [Nashville Housing Data]
GROUP BY CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant =  'N' THEN 'No'
	ELSE SoldAsVacant
	END
ORDER BY Count_of_Values; 

-- Updating the Values

UPDATE [Nashville Housing Data]
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant =  'N' THEN 'No'
	ELSE SoldAsVacant
	END

-- Checking changes

SELECT DISTINCT SoldAsVacant
FROM [Nashville Housing Data]

-------------------------------------------------------------------------------------------------------------

-- Removing Dulicates

WITH RowNumCte AS (
SELECT	* ,
		ROW_NUMBER() OVER (
							PARTITION BY
							ParcelID,
							PropertyAddress,
							SaleDate,
							SaleDate,
							LegalReference
							ORDER BY
							UniqueID
						) row_num
FROM [Nashville Housing Data]
)
SELECT *
FROM RowNumCte
WHERE row_num > 1
ORDER BY ParcelID;


-------------------------------------------------------------------------------------------------------------

-- Deleting unsused column

ALTER TABLE [Nashville Housing Data]
DROP COLUMN PropertyAddress, OwnerAddress,TaxDistrict

-- checking changes

SELECT *
FROM [Nashville Housing Data]
