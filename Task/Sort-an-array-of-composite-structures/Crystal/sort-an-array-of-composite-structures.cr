record City, name : String, country : String

cities = [{"Warsaw", "Poland"}, {"Prague", "Czech Republic"}, {"Paris", "France"},
          {"Lima", "Peru"}, {"Montevideo", "Uruguay"}, {"Bogotá", "Colombia"},
          {"Cairo", "Egypt"}, {"Yaoundé", "Cameroon"}, {"Luanda", "Angola"}]
         .map {|name, country| City.new name, country }

puts "unsorted:"
pp cities
puts "sorted:"
pp cities.sort_by &.name
