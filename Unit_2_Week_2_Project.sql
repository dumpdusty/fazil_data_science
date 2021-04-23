--Unit_2_Week_2_SQL_Project 

--I have a problem with understanding the questions. Probably it`s my bad english :( Hope we`ll find a time to discuss it later.


--1. Which campaign typically has the highest cost each year?

select campaign, year, round(Total_cost::numeric, 2) as total_cost
from (select  
	campaign, 
	date_part('year',date) as year, 
	sum(sad."cost") as Total_cost, 
	max(sum(sad."cost")) over (partition by date_part('year',date)) max 
	from public.search_ad_campaigns sac
	inner join public.search_ad_data sad on sac.campaign_id = sad.campaign_id
	group by 1,2
	order by 2,3 desc) base 
where total_cost = max
order by 3 desc 


--ladder_collection


--2.Which campaign typically has the lowest cost per conversion each year?

select campaign , year, round (Total_CPC::numeric,3) 
from 
(select campaign , date_part('year',date) as year, sum(sad."cost")/sum(sad.conversions) as Total_CPC,
min(sum(sad."cost")/sum(sad.conversions)) over (partition by date_part('year',date)) min
from public.search_ad_data sad
inner join public.search_ad_campaigns sac
 on sad.campaign_id = sac.campaign_id 
group by 1,2
order by 2,3 asc) test
where Total_CPC = min
order by 2,3 asc 


--desk organization (???)



--3.What is a year over year trend in campaign cost?

select  date_part('year',date) as year, round(sum(sad."cost")::numeric,3) as campaing_cost
from public.search_ad_data sad 
left join public.search_ad_campaigns sac on sad.campaign_id =sac.campaign_id 
group by 1
order by 1,2 desc 

-- Campaighn cost getting higher


--4.What is a year over year trend in CPC (cost/conversions)?

select date_part('year',date) as year, sum(cost)/sum(conversions) as CPC 
from public.search_ad_data sad 
group by 1
order by 1 asc 

-- CPC getting higher


--5. What would you tell the marketing leader about the campaigns? Are there any we should spend less money on?
--Are there some that are more efficient than others?

select sac.campaign, sum(cost)/sum(conversions) as CPC
from public.search_ad_data sad 
left join public.search_ad_campaigns sac 
on sac.campaign_id = sad.campaign_id 
group by 1
order by 2 desc 



--What the most expansive ad campaigns are by platform and if those campaigns are efficient on a cost/conversion (cpc) basis?

select  campaign , platform, sum(Total_CPC)
from (select sac.campaign , sap.platform, sum(sad.impressions) as TOTAL_IMPRESSIONS,
sum(sad.visits) as Total_Visits, sum(sad.clicks) as Total_Clicks, sum(sad.conversions) as Total_Conversions,
sum(sad.cost)/sum(sad.conversions) as Total_CPC
from public.search_ad_campaigns sac 
left join public.search_ad_data sad 
on sac.campaign_id = sad.campaign_id 
left join public.search_ad_platforms sap 
on sad.platform_id = sap.platform_id 
where sad.impressions >0
group by 1,2
order by 6 desc) as test
group by 1,2
order by 3 desc 



--It looks like "village_contract" by GOOGLE  is a most expansive


--Bonus:
--Your analitycs boss think this is a good metric to keep track off and asks you to create a view for a query you wrote. Create a view
--in a data_science_bootcamp database with the naming convention "vw_sem_tracking_[your name]".


create or replace view vw_sem_tracking_fazil as
select  campaign , platform, sum(Total_CPC) over (partition by campaign) sum_cpc
from (select sac.campaign , sap.platform, sum(sad.impressions) as TOTAL_IMPRESSIONS,
sum(sad.visits) as Total_Visits, sum(sad.clicks) as Total_Clicks, sum(sad.conversions) as Total_Conversions,
sum(sad.cost)/sum(sad.conversions) as Total_CPC
from public.search_ad_campaigns sac 
left join public.search_ad_data sad 
on sac.campaign_id = sad.campaign_id 
left join public.search_ad_platforms sap 
on sad.platform_id = sap.platform_id 
where sad.impressions >0
group by 1,2
order by 6 desc) as test
order by 3 desc 
