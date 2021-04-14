--Unit 2 Week 1 SQL Project Fazil merge 

--Which metro area in the country has the highest average household income in the US?

select metro_city, avg(median_hh_income)
from public.census_metro_data cmd 
group by 1
order by 2 desc

-- Bridgeport

--What metro area has the zip code with the largest population? 


select metro_city , max(population) as largest_pop
from public.census_metro_data cmd 
group by metro_city 
order by 2 desc 

--Houston

--What state has the most metro areas?

select state, count(metro_city) as metro_city_total_quantity
from public.census_metro_data cmd 
group by 1
order by 2 desc 

--CA (California)

--Which metro area has the largest proportion of people aged 70-97?

select metro_city , sum(population_age_70_74)+sum (population_age_75_79) as highest_pop_70_79
from public.census_metro_data cmd 
group by 1
order by 2 desc 

--New York


