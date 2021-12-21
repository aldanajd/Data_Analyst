########################################### Creating the Table ###########################################

USE nashville_project;

DROP TABLE IF EXISTS `nashville_housing`;
CREATE TABLE `nashville_housing` (
  `UniqueID` text,
  `ParcelID` text,
  `LandUse` text,
  `PropertyAddress` text,
  `SaleDate` text,
  `SalePrice` text,
  `LegalReference` text,
  `SoldAsVacant` text,
  `OwnerName` text,
  `OwnerAddress` text,
  `Acreage` text,
  `TaxDistrict` text,
  `LandValue` text,
  `BuildingValue` text,
  `TotalValue` text,
  `YearBuilt` text,
  `Bedrooms` text,
  `FullBath` text,
  `HalfBath` text);

########################################### Loading the Data ###########################################
#SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE 'C:/Users/aldan/Desktop/Data Analysis and Science/Data Analysis/Data Analysis Projects/SQL Projects/NASHVILLE - Data Cleaning with SQL/Nashville Housing Data for Data Cleaning.csv'
INTO TABLE nashville_housing FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS; 

########################################### Blanks to Null ###########################################
UPDATE nashville_housing
	SET 
		UniqueID = NULLIF(UniqueID, ""),
		ParcelID = NULLIF(ParcelID, ""),
		LandUse = NULLIF(LandUse, ""),
        PropertyAddress = NULLIF(PropertyAddress, ""),
        SaleDate = NULLIF(SaleDate, ""),
		SalePrice = NULLIF(SalePrice, ""),
        LegalReference = NULLIF(LegalReference, ""),
        SoldAsVacant = NULLIF(SoldAsVacant, ""),
        OwnerName = NULLIF(OwnerName, ""),
        OwnerAddress = NULLIF(OwnerAddress, ""),
        Acreage = NULLIF(Acreage, ""),
        TaxDistrict = NULLIF(TaxDistrict, ""),
        LandValue = NULLIF(LandValue, ""),
        BuildingValue = NULLIF(BuildingValue, ""),
        TotalValue = NULLIF(TotalValue, ""),
        YearBuilt = NULLIF(YearBuilt, ""),
        Bedrooms = NULLIF(Bedrooms, ""),
        FullBath = NULLIF(FullBath, ""),
        HalfBath = NULLIF(HalfBath, "");
 
########################################### Cleaning the Data ###########################################

########################### Change SaleDate Format ###########################

(#Selecting/Testing the Date Format
SELECT 	SaleDate, CONVERT(STR_TO_DATE(SaleDate,'%M %d, %Y'),DATE) as SaleDateFormated
FROM 	nashville_housing
);

#Updating the Date Format
UPDATE  nashville_housing
SET 	SaleDate = CONVERT(STR_TO_DATE(SaleDate,'%M %d, %Y'),DATE);

########################### PropertyAddress ###########################

(#Selecting/Testing: Filling the Nulls from PropertyAddress
SELECT IFNULL(a.propertyaddress, b.propertyaddress)
FROM nashville_housing a
JOIN nashville_housing b
ON a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS NULL);

#Updating the Nulls from PropertyAddress
UPDATE nashville_housing a
        JOIN nashville_housing b 
        ON a.parcelid = b.parcelid
        AND a.uniqueid <> b.uniqueid 
SET 
    a.propertyaddress = IFNULL(a.propertyaddress, b.propertyaddress);

#Selecting/Testing: Splitting PropertyAddress into StreetAddress and City
SELECT 
SUBSTRING(PropertyAddress, 1, LOCATE(",", PropertyAddress) -1) AS PropertyAddressStreet, SUBSTRING(PropertyAddress, LOCATE(",", PropertyAddress) + 1) as PropertyAddressCity
FROM nashville_project.nashville_housing;

ALTER TABLE nashville_housing
ADD COLUMN PropertyStreetAddress VARCHAR(255) AFTER LandUse,
ADD COLUMN PropertyCity CHAR(100) AFTER PropertyStreetAddress;

UPDATE nashville_housing
	SET	
		PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, LOCATE(",", PropertyAddress) -1),
		PropertyCity = SUBSTRING(PropertyAddress, LOCATE(",", PropertyAddress) + 1);

########################### Splitting OwnerAddress into StreetName, City and State ###########################
SELECT 
	REPLACE(OwnerAddress,"  "," "),
	SUBSTRING_INDEX(REPLACE(OwnerAddress,"  "," "),",",1) as StreetName,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress,"  "," "),",",2),",",-1)) as City,
	TRIM(SUBSTRING_INDEX(OwnerAddress,",",-1)) as State
FROM nashville_project.nashville_housing;

ALTER TABLE nashville_housing
	ADD COLUMN OwnerAddressStreet VARCHAR(255) AFTER OwnerName,
	ADD COLUMN OwnerAddressCity CHAR(20) AFTER OwnerAddressStreet,
	ADD COLUMN OwnerAddressState CHAR(20) AFTER OwnerAddressCity;

UPDATE nashville_housing
	SET	
		OwnerAddressStreet = SUBSTRING_INDEX(REPLACE(OwnerAddress,"  "," "),",",1),
		OwnerAddressCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress,"  "," "),",",2),",",-1)),
		OwnerAddressState = TRIM(SUBSTRING_INDEX(OwnerAddress,",",-1));

########################### SoldAsVacant From Y/N to Yes/No ###########################

(####### Selecting/Testing: Distinct and Count for the different values in SoldAsVacant (Diagnose)
SELECT 
	DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashville_project.nashville_housing
GROUP BY SoldAsVacant
ORDER BY 2);

#Selecting/Testing: Conditions to solve the problems
SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = "Y" THEN "Yes"
        WHEN SoldAsVacant = "N" THEN "No"
        ELSE SoldAsVacant
	END 
FROM nashville_project.nashville_housing;

UPDATE nashville_housing 
SET 
    SoldAsVacant = 
    CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;

########################### Removing Duplicates - Own criteria when it comes to define a "Duplicate" ###########################

#Adding and Index Column
ALTER TABLE nashville_housing ADD COLUMN idx_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST;

####### Method Number 1
SELECT *
FROM nashville_housing a
JOIN nashville_housing b
WHERE a.idx_number <> b.idx_number
AND a.SaleDate = b.SaleDate
AND a.SalePrice = b.SalePrice
AND a.ParcelID = b.ParcelID
AND a.OwnerAddress = b.OwnerAddress
ORDER BY a.idx_number DESC;

DELETE a
FROM nashville_housing a
JOIN nashville_housing b
WHERE a.idx_number > b.idx_number
AND a.SaleDate = b.SaleDate
AND a.SalePrice = b.SalePrice
AND a.ParcelID = b.ParcelID
AND a.OwnerAddress = b.OwnerAddress;

####### Method Number 2
WITH RowNumberCTE
AS
(SELECT * , ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, OwnerAddress, LandValue, SalePrice, SaleDate) as RowNumber

FROM nashville_housing 

)
DELETE  #Change to Select to Check Before the Delete
FROM RowNumberCTE
WHERE RowNumber > '1';
#ORDER BY RowNumber DESC;

####### Method Number 3
#Selecting/Testing - Number of Rows that has the same Fields Values)
SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, OwnerAddress, LandValue, SalePrice, SaleDate ORDER BY idx_number) as RowNumber
FROM nashville_housing
ORDER BY idx_number ASC;

#Selecting/Testing - Index of the Number of Rows that has the same Fields Values)
(SELECT idx_number 
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, OwnerAddress, LandValue, SalePrice, SaleDate ORDER BY idx_number) as RowNumber
				FROM nashville_housing) a
	WHERE RowNumber > '1'
    ORDER BY idx_number);

#Deleting - Index of the Number of Rows that has the same Fields Values)
DELETE  
FROM nashville_housing
WHERE idx_number IN (
	(SELECT idx_number 
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, OwnerAddress, LandValue, SalePrice, SaleDate ORDER BY idx_number) as RowNumber
				FROM nashville_housing) a
	WHERE RowNumber > '1'));

########################### Removing "$" and "," From SalePrice ###########################
SELECT SalePrice, TRIM(REPLACE(REPLACE(SalePrice, ",", ""), "$", ""))  
FROM nashville_housing;

UPDATE nashville_housing
	SET SalePrice = TRIM(REPLACE(REPLACE(SalePrice, ",", ""), "$", ""));

########################### Final Touches ###########################
### Remove Useless Columns ###
ALTER TABLE nashville_housing
DROP OwnerAddress, 
DROP PropertyAddress;

### Set Columns Datatype ###
ALTER TABLE nashville_housing
		CHANGE UniqueID UniqueID MEDIUMINT DEFAULT NULL,
        CHANGE SalePrice SalePrice INT DEFAULT NULL,
        CHANGE Acreage Acreage SMALLINT DEFAULT NULL,
        CHANGE LandValue LandValue INT DEFAULT NULL,
        CHANGE BuildingValue BuildingValue INT DEFAULT NULL,
        CHANGE TotalValue TotalValue INT DEFAULT NULL,
        #CHANGE YearBuilt YearBuilt YEAR DEFAULT NULL,  - YEAR RANGES FROM 1901' to '2155', doing this change would NULLIFY some values
        CHANGE Bedrooms Bedrooms TINYINT DEFAULT NULL,
        CHANGE FullBath FullBath TINYINT DEFAULT NULL,
        CHANGE HalfBath HalfBath TINYINT DEFAULT NULL;
        






