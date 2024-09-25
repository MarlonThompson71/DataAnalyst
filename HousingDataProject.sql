-- Cleaning Data in SQL Queries

SELECT * from nashvillehousing;



-- Standardize Date Format
SELECT 
    saledate, 
    STR_TO_DATE(saledate, '%M %d, %Y') AS converted_date 
FROM 
    nashvillehousing;
   -- SET SQL_SAFE_UPDATES = 0;
--  
-- update nashvillehousing
-- set saledate = STR_TO_DATE(saledate, '%M %d, %Y') 
select * , DATE_FORMAT(saledate, '%M %d, %Y') as AnotherDateOption from nashvillehousing;



-- Populate property address data
select * from nashvillehousing
order by ParcelID;

SELECT 
    n.parcelid, 
    n.propertyaddress, 
    h.parcelid, 
    h.propertyaddress, 
    IFNULL(n.propertyaddress, h.propertyaddress) AS property_address
FROM 
    nashvillehousing AS n 
JOIN 
    nashvillehousing AS h 
ON 
    n.parcelID = h.parcelID 
    AND n.uniqueid != h.uniqueid 
WHERE 
    n.propertyaddress IS NULL;



-- update  
--     nashvillehousing AS n 
-- JOIN 
--     nashvillehousing AS h 
-- ON 
--     n.parcelID = h.parcelID 
--     AND n.uniqueid != h.uniqueid 
--     
--     set n.propertyaddress = IFNULL(n.propertyaddress, h.propertyaddress)
-- WHERE 
--     n.propertyaddress IS NULL;
select * from nashvillehousing
order by ParcelID;





-- Breaking out address into Individual Columns(Address, City, State)
-- Extracting


select propertyAddress from nashvillehousing;


SELECT SUBSTRING(propertyaddress, 1, INSTR(propertyaddress, ',') -1) AS Address,
SUBSTRING(propertyaddress, INSTR(propertyaddress, ',') +1, length(propertyaddress)) as City
FROM nashvillehousing;

-- Alter table nashvillehousing
-- add PropertySplitAddress varchar(255);
-- update nashvillehousing
-- set PropertySplitAddress = SUBSTRING(propertyaddress, 1, INSTR(propertyaddress, ',') -1);

-- Alter table nashvillehousing
-- add PropertySplitCity varchar(255);
-- update nashvillehousing
-- set PropertySplitCity = SUBSTRING(propertyaddress, INSTR(propertyaddress, ',') +1, length(propertyaddress))
-- ;

select * from nashvillehousing;




-- Breaking out address into Individual Columns(Address, City, State) for owner

select ownerAddress from nashvillehousing;

SELECT Trim(SUBSTRING_INDEX(owneraddress, ',', -1)) AS State,
Trim(Substring_index(SUBSTRING_INDEX(owneraddress, ',', -2),',',1))as city,
Trim(SUBSTRING_INDEX(owneraddress, ',', 1)) as address
FROM nashvillehousing;

-- Alter table nashvillehousing
-- add OwnerSplitAddress varchar(255);
-- update nashvillehousing
-- set OwnerSplitAddress = Trim(SUBSTRING_INDEX(owneraddress, ',', 1))
-- ;


-- Alter table nashvillehousing
-- add OwnerSplitState varchar(255);
-- update nashvillehousing
-- set OwnerSplitState = Trim(SUBSTRING_INDEX(owneraddress, ',', -1))
-- ;

-- Alter table nashvillehousing
-- add OwnerSplitCity varchar(255);
-- update nashvillehousing
-- set OwnerSplitCity = Trim(Substring_index(SUBSTRING_INDEX(owneraddress, ',', -2),',',1))
-- ;


Select OwnerSplitCity, OwnerSplitState, OwnerSplitaddress
from nashvillehousing;





-- Change Y and N to yes and no in "Sold as Vacant" field

select distinct(SoldAsVacant), count(soldasvacant)
from nashvillehousing
group by soldasvacant
order by 2;



select soldasvacant,
Case 
when soldasvacant = 'y' Then 'yes'
when soldasvacant = 'n' then 'no'
else soldasvacant
end

from nashvillehousing;


update nashvillehousing
set soldasvacant = 
Case 
when soldasvacant = 'y' Then 'yes'
when soldasvacant = 'n' then 'no'
else soldasvacant
end;






-- Remove Duplicates

WITH RowNumCTE as(
select *, 
	row_number() Over(
    Partition by parcelid, 
				 propertyaddress, 
                 saleprice, 
                 saledate, 
                 legalreference
                 Order By uniqueid
                 ) row_num
from nashvillehousing)





-- DELETE n
-- FROM nashvillehousing n
-- JOIN (
--     SELECT 
--         uniqueid
--     FROM (
--         SELECT 
--             uniqueid, 
--             ROW_NUMBER() OVER (
--                 PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference
--                 ORDER BY uniqueid
--             ) AS row_num
--         FROM nashvillehousing
--     ) AS subquery
--     WHERE row_num > 1
-- ) AS duplicates
-- ON n.uniqueid = duplicates.uniqueid;

 select * from RownumCTE
where row_num > 1
 order by propertyaddress;







-- Delete unused columns

select * from nashvillehousing;

-- Alter Table nashvillehousing
-- drop column owneraddress,
-- drop column taxdistrict, 
-- drop column propertyaddress;











