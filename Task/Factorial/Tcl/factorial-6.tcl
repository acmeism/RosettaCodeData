puts [ifact 30]
puts [rfact 30]
puts [ifact_caching 30]

set n 400
set iterations 10000
puts "calculate $n factorial $iterations times"
puts "ifact: [time {ifact $n} $iterations]"
puts "rfact: [time {rfact $n} $iterations]"
# for the caching proc, reset the cache between each iteration so as not to skew the results
puts "ifact_caching: [time {ifact_caching $n; unset -nocomplain fact_cache} $iterations]"
