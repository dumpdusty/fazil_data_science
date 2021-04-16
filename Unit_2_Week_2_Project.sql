--Unit_2_Week_2_SQL_Project

--1. Which campaign typically has the highest cost each year?

select  distinct sa.sac.campaign , sum(sad."cost" )
from public.search_ad_campaigns sac 
inner join public.search_ad_data sad 
on sac.campaign_id = sad.campaign_id 
group by sac.campaign
order by sum(sad."cost") desc 

--ladder_collection


--2.Which campaign typically has the lowest cost per conversion each yer?

select sac.campaign , sum(sad.conversions) as Total_Conversions
from public.search_ad_campaigns sac 
left join public.search_ad_data sad on sac.campaign_id =sad.campaign_id 
group by 1 
order by 2 asc 

--perspective leader

--3.What is a year over year trend in campaign cost?

select  distinct sac.campaign , date_part('year',date), sum(sad."cost") 
from public.search_ad_data sad 
right join public.search_ad_campaigns sac on sad.campaign_id =sac.campaign_id 
group by 1, 2
order by 2 asc 


--4.What is a year over year trend in CPC (cost/conversions)?


select date_part('year',date), sum(cost)/sum(conversions) as CPC
from public.search_ad_data sad 
group by 1
order by 1 desc 




--5. What would you tell the marketing leader about the campaigns? Are there any we should spend less money on?

--Are there some that are more efficient than others?

