require 'date'
CYCLES = {physical: 23, emotional: 28, mental: 33}

def biorhythms(date_of_birth, target_date = Date.today.to_s)
  days_alive = Date.parse(target_date) - Date.parse(date_of_birth)
  CYCLES.each do |name, num_days|
    cycle_day = days_alive % num_days
    state = case cycle_day
      when 0, num_days/2 then "neutral"
      when (1.. num_days/2) then "positive"
      when (num_days/2+1..num_days) then "negative"
    end
    puts "%-10s: cycle day %2s, %s" % [name, cycle_day.to_i, state]
  end
end

biorhythms("1943-03-09", "1972-07-11")
