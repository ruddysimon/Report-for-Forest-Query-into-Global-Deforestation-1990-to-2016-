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


-- 2. REGIONAL OUTLOOK


--  What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016,
--  and which had the LOWEST, to 2 decimal places?
select * 
from v_forestation
where year = '2016' and country_name = 'World';


with t1 as(select region,
	   sum(forest_area_sqkm) as "total_forest_area_2016",
	   sum(total_area_sqkm) as "total_land_area_2016"
from v_forestation
where year = '2016' and country_name <> 'World'
group by region)
select region,
	   round(cast((total_forest_area_2016 / total_land_area_2016)*100 as numeric),2) as "percent_forest_2016"
from t1
group by 1,2
order by 2 desc



-- b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, 
-- and which had the LOWEST, to 2 decimal places?
select *
from v_forestation
where year = '1990' and country_name = 'World'


with t1 as(select region,
	   sum(forest_area_sqkm) as "total_forest_area_1990",
	   sum(total_area_sqkm) as "total_land_area_1990"
from v_forestation
where year = '1990' and country_name <> 'World'
group by region)
select region,
	   round(cast((total_forest_area_1990 / total_land_area_1990)*100 as numeric),2) as "percent_forest_1990"
from t1
group by 1,2
order by 2 desc


-- COUNTRY-LEVEL DETAIL


select current_year.country_name,(current_year.forest_area_sqkm - previous_year.forest_area_sqkm) as "Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990') and current_year.country_name = previous_year.country_name
where (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) is not null
order by 2 desc
limit 2;



-- Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?
select current_year.country_name,
	  (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) as "Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990') and current_year.country_name = previous_year.country_name
where (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) is not null
order by 2 desc
limit 5;




-- Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?
select current_year.country_name ,
	  (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) / (previous_year.forest_area_sqkm)*100 as "Percent_Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990') and current_year.country_name = previous_year.country_name
where (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) / (previous_year.forest_area_sqkm)*100 is not null
order by 2 desc
limit 5;




-- Top 5 Amount Decrease in Forest Area by Country, 1990 & 2016:
select current_year.country_name, 
	   r.region,
	  (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) as "Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990') and current_year.country_name = previous_year.country_name
join regions as r
on current_year.country_name = r.country_name and current_year.country_code = r.country_code
where (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) is not null and 
current_year.country_name <> 'World'
order by 3;




-- Top 5 Percent Decrease in Forest Area by Country, 1990 & 2016:
select current_year.country_name,
	   r.region,
	  (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) / (previous_year.forest_area_sqkm)*100 as "Percent_Difference"
from forest_area as "current_year"
join forest_area as "previous_year"
on (current_year.year = '2016' and previous_year.year = '1990') and current_year.country_name = previous_year.country_name
join regions as r
on current_year.country_name = r.country_name and current_year.country_code = r.country_code
where (current_year.forest_area_sqkm - previous_year.forest_area_sqkm) / (previous_year.forest_area_sqkm)*100 is not null
order by 3;



-- c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
select quartile_range, count(s2.country_name)
from
	(select country_name,
	 	   case when percent_forest <= 25 then '0 to 25 percentile'
				when percent_forest between 25 and 50 then '25 to 50 percentile'
				when percent_forest between 50 and 75 then '50 to 75 percentile'
				else 'above 75 percentile' end as "quartile_range"
		from (select * 
		from v_forestation
		where year = '2016' and percent_forest is not null) as s1) as s2
group by 1
order by 1;




-- d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
select s2.country_name
from (select country_name,
	 	   case when percent_forest <= 25 then '0 to 25 percentile'
				when percent_forest between 25 and 50 then '25 to 50 percentile'
				when percent_forest between 50 and 75 then '50 to 75 percentile'
				else 'above 75 percentile' end as "quartile_range"
		from (select * 
		from v_forestation
		where year = '2016' and percent_forest is not null) as s1) as s2
where quartile_range = 'above 75 percentile'



-- e. How many countries had a percent forestation higher than the United States in 2016?
select country_name, region, percent_forest
from v_forestation
where year = 2016 and percent_forest > 
									(select percent_forest
									from v_forestation
									where country_name = 'United States' and year = 2016)





