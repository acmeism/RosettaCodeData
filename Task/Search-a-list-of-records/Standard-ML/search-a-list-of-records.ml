type city = { name : string, population : real }

val citys : city list = [
        { name = "Lagos",                population = 21.0  },
        { name = "Cairo",                population = 15.2  },
        { name = "Kinshasa-Brazzaville", population = 11.3  },
        { name = "Greater Johannesburg", population =  7.55 },
        { name = "Mogadishu",            population =  5.85 },
        { name = "Khartoum-Omdurman",    population =  4.98 },
        { name = "Dar Es Salaam",        population =  4.7  },
        { name = "Alexandria",           population =  4.58 },
        { name = "Abidjan",              population =  4.4  },
        { name = "Casablanca",           population =  3.98 } ]

val firstCityi   = #1 (valOf (List.findi (fn (_, city) => #name(city) = "Dar Es Salaam") citys))
val firstBelow5M = #name (valOf (List.find (fn city => #population(city) < 5.0) citys))
val firstPopA    = #population (valOf (List.find (fn city => String.substring (#name(city), 0, 1) = "A") citys))
