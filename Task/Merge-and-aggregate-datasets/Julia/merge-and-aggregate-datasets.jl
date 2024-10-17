using CSV, DataFrames, Statistics

# load data from csv files
#df_patients = CSV.read("patients.csv", DataFrame)
#df_visits = CSV.read("visits.csv", DataFrame)

# create DataFrames from text that is hard coded, so use IOBuffer(String) as input
str_patients = IOBuffer("""PATIENT_ID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz
""")
df_patients = CSV.read(str_patients, DataFrame)
str_visits = IOBuffer("""PATIENT_ID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
""")
df_visits = CSV.read(str_visits, DataFrame)

# merge on PATIENT_ID, using an :outer join or we lose Kurtz, who has no data, sort by ID
df_merge = sort(join(df_patients, df_visits, on="PATIENT_ID", kind=:outer), (:PATIENT_ID,))

fnonmissing(a, f) = isempty(a) ? [] : isempty(skipmissing(a)) ? a[1] : f(skipmissing(a))

# group by patient id / last name and then aggregate to get latest visit and mean score
df_result = by(df_merge, [:PATIENT_ID, :LASTNAME]) do df
    DataFrame(LATEST_VISIT = fnonmissing(df[:VISIT_DATE], maximum),
              SUM_SCORE = fnonmissing(df[:SCORE], sum),
              MEAN_SCORE = fnonmissing(df[:SCORE], mean))
end
println(df_result)
