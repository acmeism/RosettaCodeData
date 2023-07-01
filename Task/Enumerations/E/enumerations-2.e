interface Fruit guards FruitStamp {}
def apple  implements FruitStamp {}
def banana implements FruitStamp {}
def cherry implements FruitStamp {}

def eat(fruit :Fruit) { ... }
