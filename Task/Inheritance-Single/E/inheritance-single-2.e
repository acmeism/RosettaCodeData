def [Animal, AnimalStamp] := makeType("Animal", [])

def [Cat, CatStamp] := makeType("Cat", [AnimalStamp])
def [Dog, DogStamp] := makeType("Dog", [AnimalStamp])

def [Lab, LabStamp] := makeType("Lab", [DogStamp])
def [Collie, CollieStamp] := makeType("Collie", [DogStamp])
