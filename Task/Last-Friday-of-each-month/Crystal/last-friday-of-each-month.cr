def last_fridays_in_year (year)
  (1..12).map { |month|
    last_day = Time.utc(year, month, Time.days_in_month(year, month))
    last_day -= ((last_day.day_of_week.value - Time::DayOfWeek::Friday.value) % 7).days
  }
end

last_fridays_in_year(2025).each do |t|
  puts t.to_s("%Y-%m-%d")
end
