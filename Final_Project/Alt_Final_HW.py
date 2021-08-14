import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data
import numpy as np
from sklearn.cluster import KMeans
from sklearn.neighbors import KNeighborsClassifier
import random
from sklearn.model_selection import train_test_split

custom_theme=theme(panel_background = element_rect(fill = 'white'), 
          panel_grid_major = element_line(colour = 'grey', size=0.5, linetype='dashed'), 
          panel_border = element_rect(fill=None, color='grey', size=0.5, linetype='solid'))
  
#Reading .csv file
maindf=pd.read_csv("C:/Users/fmamm/OneDrive/Documents/RA BootCamp/fazil_data_science_bootcamp_HW/Final_Project/hate_crimes.csv")

maindf.info()

#Rename the variables
maindf=maindf.rename(columns={'share_population_with_high_school_degree':'share_hs',
                              'avg_hatecrimes_per_100k_fbi':'ave_hcrimes',
                              'share_population_in_metro_areas':'metro_pop',
                              'share_unemployed_seasonal':'u_share',
                              'share_non_citizen':'nc_share',
                              'share_white_poverty':'w_pov',
                              'share_non_white':'nw_share'})

#Replacing Nan values
maindf['share_hs']=maindf['share_hs'].fillna(0)
maindf['ave_hcrimes']=maindf['ave_hcrimes'].fillna(0)


#Creating a plot
(
    ggplot(maindf) +
    geom_point(aes(x = 'share_hs', 
                   y='ave_hcrimes')) + 
    labs(
        title ='Share of High School Degree People in Average Hate Crimes',
        x = 'Share of High School Degree People',
        y = 'Average Hate Crimes',
    ) + 
    custom_theme
    )

#Run K-Means Clustering
kmeans=KMeans(n_clusters=3)

kmeans_model = kmeans.fit(maindf[['share_hs','ave_hcrimes']])

maindf['cluster'] = kmeans_model.predict(maindf[['share_hs','ave_hcrimes']])

#Plotting clusters
(
    ggplot(maindf) +
    geom_point(aes(x = 'share_hs', 
                   y='ave_hcrimes', color='cluster')) + 
    labs(
        title ='Share of High School Degree People in Average Hate Crimes',
        x = 'Share of High School Degree People',
        y = 'Average Hate Crimes',
    ) + 
    custom_theme
    )

#Hypothesis
#"Average number of hate crimes higher in tro cities has "

#Creating a plot for multivariable regression

(
 ggplot(maindf) + 
  geom_point(aes(x="ave_hcrimes",
                 y='share_hs',
                 #color='metro_pop'
                 )) + 
 geom_smooth(aes(x='ave_hcrimes',
                 y='share_hs'),
             method='lm'
             ) + 
 labs(title='ne pridumal',
      x='Average Number of Hate Crimes',
      y='Share of High School Degree'
      )
 )

#OLS estimation

est=smf.ols(formula='ave_hcrimes ~ share_hs + metro_pop', data=maindf).fit()
est.summary()

#The R-squared number is 0.079 which does not explain our dependent variable strong enough
#Both of our variables are not statistical significant

#Splitting data to train and test sets as 70/30

#Training set with 70% of data
traindf_70=maindf.sample(frac=0.70)

#Testing set with other 30% of data
testdf_30=maindf.drop(traindf.index)

#OLS estimation for training set
traindf=smf.ols(formula='ave_hcrimes ~ share_hs + metro_pop', data=traindf_70).fit()

traindf.summary()

#Prediction
testdf_30['prediction']=traindf.predict(testdf_30)

testdf_30['error_rate']=(testdf_30['prediction']-testdf_30['ave_hcrimes'])/testdf_30['ave_hcrimes']

#Creating plot to estimate a prediction

(
 ggplot(testdf_30) +
 geom_line(aes(x='ave_hcrimes',
              y='error_rate')) +
 labs(title='Average model error by average numbers of hate crimes',
      x='Average Number of Hate Crimes',
      y='Average Error Rate') +
 custom_theme
 )

np.mean(testdf_30['error_rate'])

#Average error rate is 0.341 which is way bad for prediction

#Tweaking the model by adding/changing the variables


est_1=smf.ols(formula='ave_hcrimes ~ u_share + nc_share', data=maindf).fit()
est_1.summary()

#The R-squared number is 0.091 which does not explain our dependent variable strong enough
#Both of our variables are not statistical significant

#Splitting data to train and test sets as 70/30

#Training set with 70% of data
traindf_1_70=maindf.sample(frac=0.70)

#Testing set with other 30% of data
testdf_1_30=maindf.drop(traindf_1_70.index)

#OLS estimation for training set
traindf_1_70=smf.ols(formula='ave_hcrimes ~ u_share + nc_share', data=traindf_1_70).fit()

traindf_1_70.summary()

#Prediction
testdf_1_30['prediction']=traindf_1_70.predict(testdf_1_30)

testdf_1_30['error_rate']=(testdf_1_30['prediction']-testdf_1_30['ave_hcrimes'])/testdf_1_30['ave_hcrimes']

#Creating plot to estimate a prediction

(
 ggplot(testdf_1_30) +
 geom_line(aes(x='ave_hcrimes',
              y='error_rate')) +
 labs(title='Average model error by average numbers of hate crimes.\nTweak 1',
      x='Average Number of Hate Crimes',
      y='Average Error Rate') +
 custom_theme
 )

np.mean(testdf_1_30['error_rate'])

#Average error rate is 0.188. Its looks better but still to high

#Tweaking the model by adding/changing the variables. Part 2

est_2=smf.ols(formula='ave_hcrimes ~ u_share + nc_share + w_pov + nw_share', data=maindf).fit()
est_2.summary()

#The R-squared number is 0.091 which does not explain our dependent variable strong enough
#Both of our variables are not statistical significant

#Splitting data to train and test sets as 70/30

#Training set with 70% of data
traindf_2_70=maindf.sample(frac=0.70)

#Testing set with other 30% of data
testdf_2_30=maindf.drop(traindf_2_70.index)

#OLS estimation for training set
traindf_2_70=smf.ols(formula='ave_hcrimes ~ u_share + nc_share', data=traindf_2_70).fit()

traindf_2_70.summary()

#Prediction
testdf_2_30['prediction']=traindf_2_70.predict(testdf_2_30)

testdf_2_30['error_rate']=(testdf_2_30['prediction']-testdf_2_30['ave_hcrimes'])/testdf_2_30['ave_hcrimes']

#Creating plot to estimate a prediction

(
 ggplot(testdf_2_30) +
 geom_line(aes(x='ave_hcrimes',
              y='error_rate')) +
 labs(title='Average model error by average numbers of hate crimes.\Tweak 2',
      x='Average Number of Hate Crimes',
      y='Average Error Rate') +
 custom_theme
 )

np.mean(testdf_2_30['error_rate'])

#Average error rate is 0.571. More than 50% of chance to get an error in prediction.