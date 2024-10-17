cities = [
  [name: "Lagos",                 population: 21.0 ],
  [name: "Cairo",                 population: 15.2 ],
  [name: "Kinshasa-Brazzaville",  population: 11.3 ],
  [name: "Greater Johannesburg",  population:  7.55],
  [name: "Mogadishu",             population:  5.85],
  [name: "Khartoum-Omdurman",     population:  4.98],
  [name: "Dar Es Salaam",         population:  4.7 ],
  [name: "Alexandria",            population:  4.58],
  [name: "Abidjan",               population:  4.4 ],
  [name: "Casablanca",            population:  3.98]
]

IO.puts Enum.find_index(cities, fn city -> city[:name] == "Dar Es Salaam" end)
IO.puts Enum.find(cities, fn city -> city[:population] < 5.0 end)[:name]
IO.puts Enum.find(cities, fn city -> String.first(city[:name])=="A" end)[:population]
