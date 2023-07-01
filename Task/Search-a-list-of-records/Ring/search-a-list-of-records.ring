# Project : Search a list of records

cities = [[:name = "Lagos",:population = 21.0 ],
             [:name = "Cairo",:population =  15.2 ],
             [:name = "Kinshasa-Brazzaville",:population =  11.3 ],
             [:name = "Greater Johannesburg",:population =  7.55],
             [:name = "Mogadishu",:population =  5.85],
             [:name = "Khartoum-Omdurman",:population =  4.98],
             [:name = "Dar Es Salaam",:population =  4.7 ],
             [:name = "Alexandria",:population =  4.58],
             [:name = "Abidjan",:population =  4.4 ],
             [:name = "Casablanca",:population =  3.98]]

for n = 1 to len(cities)
     if cities[n][:name] = "Dar Es Salaam"
        see n-1 + nl
     ok
next

for n = 1 to len(cities)
     if cities[n][:population] < 5.00
        see cities[n][:name] + nl
        exit
     ok
next

for n = 1 to len(cities)
     if left(cities[n][:name],1) = "A"
        see cities[n][:population] + nl
        exit
     ok
next
