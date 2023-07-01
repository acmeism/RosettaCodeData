import Utils        # From the UniLib package to get the Class class.

class Eatable:Class()
end

class Fish:Eatable(name)
    method eat(); write("Eating "+name); end
end

class Rock:Class(name)
    method eat(); write("Eating "+name); end
end

class FoodBox(A)
initially
    every item := !A do if "Eatable" == item.Type() then next else bad := "yes"
    return /bad
end

procedure main()
    if FoodBox([Fish("salmon")]) then write("Edible") else write("Inedible")
    if FoodBox([Rock("granite")]) then write("Edible") else write("Inedible")
end
