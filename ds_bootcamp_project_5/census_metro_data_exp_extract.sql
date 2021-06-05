
select*
from(
select*,
case
	when percent_pop_0_17 > .160 and percent_pop_70_80 < .055 then 'high_under_18'
	when percent_pop_0_17 < .160 and percent_pop_70_80 > .055 then 'high_70_80'
	else 'other'
	end as pop_bucket
from(select zip, 
round(((population_age_0_5+population_age_5_9+population_age_10_14+population_age_15_17)::numeric/population::numeric),3) as percent_pop_0_17,
round(((population_age_70_74+population_age_75_79::numeric)/population::numeric),3) as percent_pop_70_80, median_hh_income 
from public.census_metro_data_exp cmde 
where population > 0) main) test
where pop_bucket <> 'other'



