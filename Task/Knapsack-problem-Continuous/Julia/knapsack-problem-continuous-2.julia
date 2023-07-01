store = [KPCSupply("beef", 38//10, 36),
         KPCSupply("pork", 54//10, 43),
         KPCSupply("ham", 36//10, 90),
         KPCSupply("greaves", 24//10, 45),
         KPCSupply("flitch", 4//1, 30),
         KPCSupply("brawn", 25//10, 56),
         KPCSupply("welt", 37//10, 67),
         KPCSupply("salami", 3//1, 95),
         KPCSupply("sausage", 59//10, 98)]

sack = solve(store, 15)
println("The store contains:\n - ", join(store, "\n - "))
println("\nThe thief should take::\n - ", join(sack, "\n - "))
@printf("\nTotal value in the sack: %.2f €\n", sum(getfield.(sack, :value)))
