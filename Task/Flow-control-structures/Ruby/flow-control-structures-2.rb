values = ["1", "2.3", /pattern/]
result = values.map {|v| Integer(v) rescue Float(v) rescue String(v)}
# => [1, 2.3, "(?-mix:pattern)"]
