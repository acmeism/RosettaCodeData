cities = [ {"UK", "London"},
           {"US", "New York"},
           {"US", "Birmingham"},
           {"UK", "Birmingham"} ]

IO.inspect Enum.sort(cities)
IO.inspect Enum.sort(cities, fn a,b -> elem(a,0) >= elem(b,0) end)
IO.inspect Enum.sort_by(cities, fn {country, _city} -> country end)
IO.inspect Enum.sort_by(cities, fn {_country, city} -> city end)
