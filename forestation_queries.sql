drop view v_forestation
create view v_forestation 
as
with t1 as (select l.country_code, l.country_name, r.region, l.year, r.income_group, 2.59*(l.total_area_sq_mi) as "total_area_sqkm", f.forest_area_sqkm
from land_area as l
left join forest_area as f
on l.country_code = f.country_code and l.year = f.year
left join regions as r
on r.country_code = l.country_code)
select t1.*, 
	   t1.total_area_sqkm - t1.forest_area_sqkm as "land_area_sqkm",
	   (t1.forest_area_sqkm / t1.total_area_sqkm)*100 as "percent_forest"
from t1;


select * from v_forestation;


-- What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.
with t1 as (
select country_name,year, forest_area_sqkm
from forest_area
where year = '1990' and country_name = 'World')
select country_name, year, forest_area_sqkm
from t1


-- What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”
with t1 as (
select country_name,year, forest_area_sqkm
from forest_area
where year = '2016' and country_name = 'World')
select country_name, year, forest_area_sqkm
from t1



-- c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?
select (previous_year.forest_area_sqkm - current_year.forest_area_sqkm) as "Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990' and current_year.country_name = 'World' and previous_year.country_name = 'World');



-- d. What was the percent change in forest area of the world between 1990 and 2016?
select ((previous_year.forest_area_sqkm - current_year.forest_area_sqkm) / previous_year.forest_area_sqkm)*100 as "Percent_Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990' and current_year.country_name = 'World' and previous_year.country_name = 'World');




-- If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?
select *
from v_forestation
where year = '2016' and total_area_sqkm between 1000000 and 1400000
order by total_area_sqkm desc
