import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

os.chdir("C:/Users/JAAME/OneDrive/Desktop/contoso_100k/Python_code")

df = pd.read_csv('../Results/Customer_Retention.csv')
df

df['customer_status'].value_counts(normalize=True).mul(100)

# customer_status
# churned    90.533541
# active      9.466459


plt.figure(figsize=(10, 6))
df['customer_status'].value_counts(normalize=True).mul(100).plot(kind='bar', color=['red', 'green'])
plt.title('Customer Retention Status')
plt.xlabel('Customer Status')
plt.ylabel('Percentage (%)')
plt.xticks(rotation=0)
plt.yticks(range(0, 101, 20))
plt.show()

cohort_churn = df.groupby('cohort_year')['customer_status'].value_counts(normalize=True).mul(100).unstack()
cohort_churn

#  Churn Rate by Cohort Year
cohort_churn.plot(kind='bar', stacked=True,colormap='Set1',figsize=(10, 6))
plt.title(' Churn Rate by Cohort Year')
plt.xlabel('Cohort Year')
plt.ylabel('Percentage (%)')
plt.legend(loc='upper right')
plt.show()

#Churn Trend Over Cohort Years
plt.figure(figsize=(10, 6))
sns.lineplot(data=cohort_churn['churned'], marker='o',color='red')
plt.show()