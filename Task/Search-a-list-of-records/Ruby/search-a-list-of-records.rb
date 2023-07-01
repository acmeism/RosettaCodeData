cities = [
    {name: "Lagos", population: 21},
    {name: "Cairo", population: 15.2},
    {name: "Kinshasa-Brazzaville", population: 11.3},
    {name: "Greater Johannesburg", population: 7.55},
    {name: "Mogadishu", population: 5.85},
    {name: "Khartoum-Omdurman", population: 4.98},
    {name: "Dar Es Salaam", population: 4.7},
    {name: "Alexandria", population: 4.58},
    {name: "Abidjan", population: 4.4},
    {name: "Casablanca", population: 3.98},
]

puts cities.index{|city| city[:name] == "Dar Es Salaam"}      # => 6
puts cities.find {|city| city[:population] < 5.0}[:name]      # => Khartoum-Omdurman
puts cities.find {|city| city[:name][0] == "A"}[:population]  # => 4.58
