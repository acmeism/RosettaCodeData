import "./dynamic" for Tuple

var Element = Tuple.create("Element", ["record", "index"])

var findFirst = Fn.new { |seq, pred|
    var i = 0
    for (e in seq) {
        if (pred.call(e)) return Element.new(e, i)
        i = i + 1
    }
    return Element.new(null, -1)
}

var City = Tuple.create("City", ["name", "pop"])

var cities = [
    City.new("Lagos", 21.0),
    City.new("Cairo", 15.2),
    City.new("Kinshasa-Brazzaville", 11.3),
    City.new("Greater Johannesburg", 7.55),
    City.new("Mogadishu", 5.85),
    City.new("Khartoum-Omdurman", 4.98),
    City.new("Dar Es Salaam", 4.7),
    City.new("Alexandria", 4.58),
    City.new("Abidjan", 4.4),
    City.new("Casablanca", 3.98)
]

var index = findFirst.call(cities) { |c| c.name == "Dar Es Salaam" }.index
System.print("Index of the first city whose name is 'Dar Es Salaam' is %(index).")
var city = findFirst.call(cities) { |c| c.pop < 5 }.record.name
System.print("First city whose population is less than 5 million is %(city).")
var pop = findFirst.call(cities) { |c| c.name[0] == "A" }.record.pop
System.print("The population of the first city whose name begins with 'A' is %(pop).")
