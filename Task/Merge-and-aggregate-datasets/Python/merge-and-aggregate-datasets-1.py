# to install pandas library go to cmd prompt and type:
# cd %USERPROFILE%\AppData\Local\Programs\Python\Python38-32\Scripts\
# pip install pandas
import pandas as pd

# load data from csv files
df_patients = pd.read_csv (r'patients.csv', sep = ",", decimal=".")
df_visits = pd.read_csv (r'visits.csv', sep = ",", decimal=".")

''' # load data hard coded, create data frames
import io
str_patients = """PATIENT_ID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz
"""
df_patients = pd.read_csv(io.StringIO(str_patients), sep = ",", decimal=".")
str_visits = """PATIENT_ID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
"""
df_visits = pd.read_csv(io.StringIO(str_visits), sep = ",", decimal=".")
'''

# typecast from string to datetime so .agg can 'max' it
df_visits['VISIT_DATE'] = pd.to_datetime(df_visits['VISIT_DATE'])

# merge on PATIENT_ID
df_merge = df_patients.merge(df_visits, on='PATIENT_ID', how='left')

# groupby is an intermediate object
df_group = df_merge.groupby(['PATIENT_ID','LASTNAME'], as_index=False)

# note: you can use 'sum' instead of the lambda function but that returns NaN as 0 (zero)
df_result = df_group.agg({'VISIT_DATE': 'max', 'SCORE': [lambda x: x.sum(min_count=1),'mean']})

print(df_result)
