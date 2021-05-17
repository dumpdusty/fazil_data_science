library(tidyverse)
library(lubridate)


setwd('C:/Users/fmamm/OneDrive/Documents/RA BootCamp/R Files')

#Question_1 - DONE

q_1<-read.csv('./Unit_4_Week_1_project_raw_data.csv') %>%
filter(DATE=='2019-04-10')


#Question_2 - DONE

q_2<-read.csv('./Unit_4_Week_1_project_raw_data.csv') 
q_2_final<-q_2 %>%
  select(DATE, SNOW,SNOW_ATTRIBUTES) %>%
  separate(DATE, c('year','month','day'),sep='-') %>%
  group_by(year) %>%
  filter(month=='12' & day=='31') %>%
  summarize(snowing=sum(SNOW, na.rm=T))
  
  
  
#Question_3 - DONE

q_3<-read.csv('./Unit_4_Week_1_project_raw_data.csv') %>%
select("DATE","PRCP")
question_3_final<-q_3 %>%
  separate(DATE, c('year','month','day'),sep='-') %>%
    group_by(year) %>%
    summarise(avg_prcp=mean(PRCP, na.rm=T))
  