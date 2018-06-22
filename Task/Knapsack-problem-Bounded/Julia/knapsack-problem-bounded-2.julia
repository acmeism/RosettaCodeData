gear = [KPDSupply("map", 9, 150, 1),
        KPDSupply("compass", 13, 35, 1),
        KPDSupply("water", 153, 200, 2),
        KPDSupply("sandwich", 50, 60, 2),
        KPDSupply("glucose", 15, 60, 2),
        KPDSupply("tin", 68, 45, 3),
        KPDSupply("banana", 27, 60, 3),
        KPDSupply("apple", 39, 40, 3),
        KPDSupply("cheese", 23, 30, 1),
        KPDSupply("beer", 52, 10, 3),
        KPDSupply("suntan cream", 11, 70, 1),
        KPDSupply("camera", 32, 30, 1),
        KPDSupply("T-shirt", 24, 15, 2),
        KPDSupply("trousers", 48, 10, 2),
        KPDSupply("umbrella", 73, 40, 1),
        KPDSupply("waterproof trousers", 42, 70, 1),
        KPDSupply("waterproof overclothes", 43, 75, 1),
        KPDSupply("note-case", 22, 80, 1),
        KPDSupply("sunglasses", 7, 20, 1),
        KPDSupply("towel", 18, 12, 2),
        KPDSupply("socks", 4, 50, 1),
        KPDSupply("book", 30, 10, 2)]

pack = solve(gear, 400)
println("The hiker should pack: \n - ", join(pack, "\n - "))
println("\nPacked weight: ", sum(getfield.(pack, :weight)), " kg")
println("Packed value: ", sum(getfield.(pack, :value)), " €")
