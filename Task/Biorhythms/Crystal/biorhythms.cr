module BioRhythms
  enum Cycle
    Physical = 23
    Emotional = 28
    Mental = 33
  end

  Quadrants = [ {"up and raising", "peak"},
                {"up but falling", "transition"},
                {"down and falling", "valley"},
                {"down but raising", "transition"} ]

  def self.report (birthday, date = Time.utc)
    # regularize to avoid fractional days difference
    birthday, date = birthday.to_utc, date.to_utc
    birthday -= birthday.time_of_day
    date -= date.time_of_day

    days = (date - birthday).days

    puts "Born #{birthday.to_s("%F")}, Target #{date.to_s("%F")}"
    puts "Day #{days}:"
    Cycle.each do |kind, length|
      position = days % length
      quadrant = (position / length * 4).to_i
      percentage = (Math.sin(position / length * 2 * Math::PI)*1000).to_i / 10
      description = if percentage > 95
                      "peak"
                    elsif percentage < -95
                      "valley"
                    elsif percentage.abs < 5
                      "critical transition"
                    else
                      transition = date + ((quadrant + 1)/4 * length).to_i.days - position.days
                      trend, the_next = Quadrants[quadrant]
                      "#{percentage}% (#{trend}, next #{the_next} #{transition.to_s("%F")})"
                    end
      puts "%-13s %2d: %s" % {kind.to_s + " day", position, description}
    end
  end
end

[{"1943-03-09", "1972-07-11"},
 {"1809-01-12", "1863-11-19"},
 {"1809-02-12", "1863-11-19"}].each do |bd, target|
  BioRhythms.report Time.parse_utc(bd, "%F"), Time.parse_utc(target, "%F")
  puts
end
