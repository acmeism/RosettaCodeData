using DataFrames

A = DataFrame(Age = [27, 18, 28, 18, 28], Name = ["Jonah", "Alan", "Glory", "Popeye", "Alan"])
B = DataFrame(Name = ["Jonah", "Jonah", "Alan", "Alan", "Glory"],
    Nemesis = ["Whales", "Spiders", "Ghosts", "Zombies", "Buffy"])
AB = join(A, B, on = :Name)

@show A B AB
