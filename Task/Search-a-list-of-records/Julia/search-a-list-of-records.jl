using DataFrames

dataset = DataFrame(name=["Lagos", "Cairo", "Kinshasa-Brazzaville", "Greater Johannesburg", "Mogadishu",
                          "Khartoum-Omdurman", "Dar Es Salaam", "Alexandria", "Abidjan", "Casablanca"],
                    population=[21.0, 15.2, 11.3, 7.55, 5.85, 4.98, 4.7, 4.58, 4.4, 3.98])

print("Find the (one-based) index of the first city in the list whose name is \"Dar Es Salaam\": ")
println(findfirst(dataset[:name], "Dar Es Salaam"))
print("Find the name of the first city in this list whose population is less than 5 million: ")
println(dataset[first(find(dataset[:population] .< 5)), :name])
print("Find the population of the first city in this list whose name starts with the letter \"A\": ")
println(dataset[first(find(startswith.(dataset[:name], 'A'))), :population])
