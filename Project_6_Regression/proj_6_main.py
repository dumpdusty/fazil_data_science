# -*- coding: utf-8 -*-
"""
Created on Mon Jun 28 11:10:54 2021

@author: fmamm
"""

import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data
import numpy as np

#Extracting data

women_employment=data("Mroz") 

#Building the plot

(ggplot(women_employment)+
geom_point(aes(x='hoursh', y='hoursw', color='child6')))

#Null Hypothesis:
#Variables named "husband wage", "number of children under 6 years old" and "wife`s education" will predict "wife`s hours of work"


#Calculating OLS

est_hoursw=smf.ols(formula='hoursw ~ wageh + child6 + educw', data=women_employment).fit()
est_hoursw.summary()

#All of those variables are statistical significant

#Magnitude for:
    #"husband wage" is -28.7944 - that`s mean as more the husband earns as less wife working
    #"number of children under 6 years old" is -392.7414 - presence of small children strongly descreasing wife`s working hours
    #"wife`s education" is +65.5197 - women with high education working more.

#But the R-squared number  (0.084) does not explain our dependent variable strong enough




