date1 = Time.parse_utc("2025-01-01", "%F")
date2 = Time.parse_utc("2025-11-18", "%F")

print (date2 - date1).days, " days between ", date1.to_s("%F"), " and ", date2.to_s("%F")
puts
