# A web experience benchmark report of popular footwear companies

### Data Source

- Using Google's BigQuery interface at https://console.cloud.google.com/bigquery - query the crux data set
- Dataset: `chrome-ux-report`

- SQL query example:

```sql
SELECT * FROM `chrome-ux-report.materialized.country_summary` where (yyyymm = 202401 ) and country_code='us' 
and (origin='https://www.nike.com' 
or origin='https://www.adidas.com'
or origin='https://www.underarmour.com'
or origin='https://www.hoka.com'
or origin='https://www.adidas.com'
or origin='https://www.adidas.com'
or origin='https://www.on.com'
or origin='https://www.newbalance.com'
or origin='https://www.reebok.com/')

```

#

There are a number of tables within the `chrome-ux-report`, many have a histogram type layout and are very data intensive.  

Given that, data quotas were met, therefore the scope of this report was adjusted to what could be queried within the free tier.

Looking at the `materialized` table and by `country_summary`, there was enough useful information to make a reasonably helpful report in R

### Steps

- get data from BigQuery, repeat sql states, as shown above, for each month (note data is aggregated by month in BigQuery)
- export each query result to a .csv file
- in **R Studio**: create datasets and show a series of  graphs to demonstrate how different companies rank against each other. 
- goal: show how the user experiences differ from site to site.
