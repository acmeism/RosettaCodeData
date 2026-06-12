using Dates

@show Day(DateTime("2019-09-30") - DateTime("2019-01-01"))

@show Day(DateTime("2019-03-01") - DateTime("2019-02-01"))

@show Day(DateTime("2020-03-01") - DateTime("2020-02-01"))

@show Day(DateTime("2029-03-29") - DateTime("2019-03-29"))
