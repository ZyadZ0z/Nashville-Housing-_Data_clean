-- cleanning data in sql quires 


Select 
* 
from nash_house.`nashville housing`;


-- Standardize Date format 


SELECT 
    SaleDate, 
    DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'), '%e-%c-%Y') AS formatted_salesdate
   from nash_house.`nashville housing`;
    
    
    
    
    -- disable safe mode of sql work bench 



    SET SQL_SAFE_UPDATES = 0;



update nash_house.`nashville housing`
    set  SaleDate =  DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'), '%e-%c-%Y');
    
select 
* 
from nash_house.`nashville housing`;




-- populate property Address data and check for nulls to remove it 


SELECT 
    PropertyAddress
from nash_house.`nashville housing`
order by ParcelID;






select 
a.ParcelID,
a.PropertyAddress,
b.ParcelID,
b.PropertyAddress,
isnull(a.PropertyAddress) a_null,
isnull(b.PropertyAddress)b_null
from nash_house.`nashville housing` a 
    join nash_house.`nashville housing` b
    on a.ParcelID=b.ParcelID  
    and 
    a.UniqueID<>b.UniqueID;
    
    
    
    
UPDATE nash_house.`nashville housing`a
JOIN nash_house.`nashville housing` b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;






-- Breaking out address into individual  columns 


    select 
    propertyaddress 
    from nash_house.`nashville housing`;




select 
propertyaddress ,
TRIM(SUBSTRING_INDEX(propertyaddress, ',', -1)) AS property_split_city ,
 TRIM(SUBSTRING_INDEX(propertyaddress, ',', 1)) AS property_split_address 
from nash_house.`nashville housing`;

    
    


alter table nash_house.`nashville housing`
add property_split_city  nvarchar(255);

update nash_house.`nashville housing`
set property_split_city= TRIM(SUBSTRING_INDEX(propertyaddress, ',', -1));




alter table nash_house.`nashville housing`
add property_split_address  nvarchar(255);


update nash_house.`nashville housing`
set property_split_address = TRIM(SUBSTRING_INDEX(propertyaddress, ',', 1));



select 
TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS Owner_split_Address,        
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS owner_split_city, 
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS owner_split_state         
from nash_house.`nashville housing`;




alter table nash_house.`nashville housing`
add Owner_split_Address  nvarchar(255);

update nash_house.`nashville housing`
set Owner_split_Address=TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1));






alter table nash_house.`nashville housing`
add owner_split_city  nvarchar(255);

update nash_house.`nashville housing`
set owner_split_city=TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) ;





alter table nash_house.`nashville housing`
add owner_split_state  nvarchar(255);

update nash_house.`nashville housing`
set owner_split_state= TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));




select * 
from nash_house.`nashville housing`;





-- change y And N in 'sold as Vacent ' field  


select 
distinct( SoldAsVacant), 
count(SoldAsVacant) as cnt 
from nash_house.`nashville housing`
group by 1
order by 2 ;





select  SoldAsVacant,
case when SoldAsVacant ='Y' then 'Yes' 
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end 
from nash_house.`nashville housing`;


update nash_house.`nashville housing` 
set SoldAsVacant= case when SoldAsVacant ='Y' then 'Yes' 
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end ;




-- Remove Duplicates 







WITH rownumcte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY 
           ParcelID, 
           PropertyAddress,
           SaleDate,
           SalePrice, 
           LegalReference
           ORDER BY UniqueID) AS ROW_NUM
    FROM nash_house.`nashville housing`
)
select *
 FROM rownumcte
 where ROW_NUM >1;
 
 
 -- to delete these duplicates 
 

WITH rownumcte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY 
           ParcelID, 
           PropertyAddress,
           SaleDate,
           SalePrice, 
           LegalReference
           ORDER BY UniqueID) AS ROW_NUM
    FROM nash_house.`nashville housing`
)
delete
 FROM rownumcte
 where ROW_NUM >1;
 
 
 
 
 
 
 
 
 
 
 -- Delete  Un used columns 
 
 select 
 * 
 from nash_house.`nashville housing`; 
 
 
 
 ALTER TABLE nash_house.`nashville housing`
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress;

 
 
 ALTER TABLE nash_house.`nashville housing`
 drop column SaleDate
 
 
 
