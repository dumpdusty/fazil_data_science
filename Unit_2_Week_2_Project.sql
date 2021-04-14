--Unit_2_Week_2_SQL_Project

--1. Which campaign tipycally has the highest cost each year?


select  sac.campaign , sum(sad."cost" )
from public.search_ad_campaigns sac 
inner join public.search_ad_data sad 
on sac.campaign_id = sad.campaign_id 
group by sac.campaign
order by sum(sad."cost") desc 

