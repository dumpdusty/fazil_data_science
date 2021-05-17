Unit_3_Week_1_project_by Fazil aka Dusty

--1.What are the top 5 metros by population?
	
	select  distinct metro_city, sum(population) as total_population
	from public.census_metro_data_exp
	group by 1
	order by 2 desc 
	limit 5
	

--2.For those metro areas, what does the spread of median_hh_income look like?

select cmde.metro_city, median_hh_income
from public.census_metro_data_exp cmde
inner join
		(select  distinct metro_city, sum(population) as total_population
	from public.census_metro_data_exp
	group by 1
	order by 2 desc 
	limit 5) top5
on cmde.metro_city=top5.metro_city
order by 1

--see answer in excel file



--3.What does the spread of the % of students look like?

select zip, cmde.metro_city, 
round((sum(population_age_10_14 + population_age_15_17 + population_age_5_9)/sum(population)::numeric*100),3) as students_proportion
from public.census_metro_data_exp cmde
inner join
		(select  distinct metro_city, sum(population) as total_population
		from public.census_metro_data_exp
		group by 1
		order by 2 desc 
		limit 5) top5
on cmde.metro_city=top5.metro_city
where population >0
group by 1,2
order by 2

--see answer in excel file

--4.Which zip codes in each metro area should receive the most federal funding?
--  locations with high percentages of children age 5-18 and with lower than average income

select main.zip, main.metro_city 
from(
	select distinct cmde.zip,  cmde.metro_city, stprop.students_proportion, sum(median_hh_income) as total_income, 
	rank () over (partition by cmde.metro_city order by stprop.students_proportion desc) as ranking_by_proportion
	from public.census_metro_data_exp cmde
	inner join
			(select  distinct metro_city, sum(population) as total_population
		from public.census_metro_data_exp
		group by 1
		order by 2 desc 
		limit 5) top5
	on cmde.metro_city=top5.metro_city
	inner join 
			(select zip, metro_city, round((sum(population_age_10_14 + population_age_15_17 + population_age_5_9)/
			sum(population)::numeric*100),3) as students_proportion
			from public.census_metro_data_exp
			where population >0
			group by 1,2) stprop
	on cmde.zip=stprop.zip
	where 
	median_hh_income <(select avg(median_hh_income) from public.census_metro_data_exp)
	and stprop.students_proportion <> 0
		group by 1,2,3
		order by 2,5) main 
	where ranking_by_proportion = 1

	
