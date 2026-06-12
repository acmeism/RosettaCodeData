sailors = ["Adrian", "Caspian", "Dune", "Finn", "Fisher", "Heron", "Kai",
           "Ray", "Sailor", "Tao"]

ladies = ["Ariel", "Bertha", "Blue", "Cali", "Catalina", "Gale", "Hannah",
           "Isla", "Marina", "Shelly"]

isnicegirl(s) =  Int(s[begin]) % 2 == 0

islovable(slady, ssailor) =  Int(slady[end]) % 2 == Int(ssailor[end]) % 2

for lady in ladies
    if isnicegirl(lady)
        println("Dating service should offer a date with ", lady)
        for sailor in sailors
            if islovable(lady, sailor)
                println("    Sailor ", sailor, " should take an offer to date her.")
            end
        end
    else
        println("Dating service should NOT offer a date with ", lady)
    end
end
