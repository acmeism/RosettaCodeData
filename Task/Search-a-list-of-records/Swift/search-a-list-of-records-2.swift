guard let salaamI = places.firstIndex(where: { $0.name == "Dar Es Salaam" }) else {
  fatalError()
}

print("Dar Es Salaam has index: \(salaamI)")

guard let lessThan5 = places.first(where: { $0.population < 5 }) else {
  fatalError()
}

print("First city with less than 5mil population: \(lessThan5.name)")

guard let startsWithA = places.first(where: { $0.name.hasPrefix("A") }) else {
  fatalError()
}

print("Population of first city starting with A: \(startsWithA.population)")
