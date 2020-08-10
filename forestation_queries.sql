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