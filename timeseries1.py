#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import plotly.plotly as ply
import cufflinks as cf


# In[2]:


store_id_to_filtered = 1
future_date = ""
delivery_interval = 10
zone_id = 1


# In[3]:

# File location and type
file_location = "/FileStore/tables/p1_time_series_for_stores.csv"
file_type = "csv"

# CSV options
infer_schema = "false"
first_row_is_header = "true"
delimiter = ","

# The applied options are for CSV files. For other file types, these will be ignored.
df = spark.read.format(file_type) \
  .option("inferSchema", infer_schema) \
  .option("header", first_row_is_header) \
  .option("sep", delimiter) \
  .load(file_location)

df = df.withColumn("Date",df['Date of delivery'].cast(DateType()))
#df = df.select("Store_id", "Date", "Earliest time", "Latest time", "Area id","Total number of deliveries")

df_changed = df.groupBy("Store_id","Date of delivery").agg(sum("Total number of deliveries").alias("total_deliveries")

temp_table_name = "p1_time_series_for_stores_csv"
df.createOrReplaceTempView(temp_table_name)

display(df)

raw_data =  df.select("*").toPandas()                  
raw_data.columns = raw_data.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('(', '').str.replace(')', '')

filtered_data = raw_data[raw_data['store_id'] == store_id_to_filtered ]

filtered_data['date_of_delivery'] =  pd.to_datetime(filtered_data['date_of_delivery'], format='%Y-%m-%d')

print filtered_data.head
print filtered_data.dtypes


# In[4]:


train = filtered_data
train['store_id'] = train['store_id'].astype(float)
#train['earliest_time'] = train['earliest_time'].astype(float)
#train['latest_time'] = train['latest_time'].astype(float)
#train['area_id'] = train['area_id'].astype(float) 
#train['total_number_of_deliveries'] = train['total_number_of_deliveries'].astype(float) 
train.rename(columns={'total_deliveries':'deliveries'}, inplace=True)
display(train)


# In[5]:


train.index = pd.to_datetime(train.index)
train.set_index("date_of_delivery", inplace=True)


# In[6]:


data = train.iloc[:,4] 
data.index = pd.to_datetime(data.index)
print data.dtypes


# In[7]:



import plotly.plotly as ply
import cufflinks as cf

cf.go_offline()
data.iplot(title="delivery")



# In[8]:


from plotly.plotly import plot_mpl
from statsmodels.tsa.seasonal import seasonal_decompose
result = seasonal_decompose(data, model='multiplicative')
fig = result.plot()
plot_mpl(fig)


# In[10]:


from pyramid.arima import auto_arima
import statsmodels.api as sm

stepwise_model = auto_arima(data, start_p=1, start_q=1,
                           max_p=3, max_q=3, m=12,
                           start_P=0, seasonal=True,
                           d=1, D=1, trace=True,
                           error_action='ignore',  
                           suppress_warnings=True, 
                           stepwise=True)
print(stepwise_model.aic())


# In[11]:



train1 = data.loc['2018-01-01':'2019-07-02']
test = data.loc['2019-08-06':]
stepwise_model.fit(train1)


# In[19]:


future_forecast = stepwise_model.predict(n_periods=37)
display(future_forecast)


# In[ ]:


future_forecast = pd.DataFrame(future_forecast,index = test.index, columns = ['Prediction'])


# In[ ]:





# In[ ]:




