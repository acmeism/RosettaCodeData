using DataFrames, CSV

ifn = "csv_data_manipulation_in.dat"
ofn = "csv_data_manipulation_out.dat"

df = CSV.read(ifn, DataFrame)
df.SUM = sum.(eachrow(df))
CSV.write(ofn, df)
