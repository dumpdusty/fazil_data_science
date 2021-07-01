setwd('C:/Users/fmamm/OneDrive/Documents/RA BootCamp')

library(tidyverse)
library(lubridate)

proj_5<-read.csv('./fazil_data_science_bootcamp_HW/ds_bootcamp_project_5/project_5_extraction.csv')

# Question_1: What is the average median_hh_income of the two zip code groups? 

avg_comparison<-proj_5 %>%
  group_by(pop_bucket) %>%
  summarize(avg_income=mean(median_hh_income, na.rm=T),
  stand_dev=sd(median_hh_income, na.rm=T)
  )

# Average median_hh_income:
# high_70_80 = 60302.39
# high_under_18 = 66005.08

# Question_2: What is the standard deviation of the median_hh_income in the two groups? 

# high_70_80 = 32437.40
# high_under_18 = 31290.66


# Question_3: Run a two sample T-Test to test your hypothesis? 

young_pop<-proj_5 %>% 
  filter(pop_bucket=='high_under_18')

old_pop<-proj_5 %>% 
  filter(pop_bucket=='high_70_80')

var<-var.test(young_pop$median_hh_income, old_pop$median_hh_income)

if(var$p.value < .05) {
  var=T
} else { 
  var=F}

t.test(young_pop$median_hh_income,old_pop$median_hh_income, var.equal=var)

#Question_4: Can you reject the null hypothesis? Why or why not? What does this tell you about your findings?

#No, we fail to reject the Null Hypothesis. 

#Because the P-value we get (3.344e-05) is much lower than 0.5. What`s mean that we have very low chance that 
#the averages of two samples are different`

