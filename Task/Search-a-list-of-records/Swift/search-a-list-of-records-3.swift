extension Collection {
  func firstIndex<V: Equatable>(
    withProperty prop: KeyPath<Element, V>,
    _ op: (V, V) -> Bool,
    _ val: V
  ) -> Index? {
    for i in indices where op(self[i][keyPath: prop], val) {
      return i
    }

    return nil
  }
}

guard let salaamI = places.firstIndex(withProperty: \.name, ==, "Dar Es Salaam") else {
  fatalError()
}

print("Dar Es Salaam has index: \(salaamI)")

guard let lessThan5I = places.firstIndex(withProperty: \.population, <, 5) else {
  fatalError()
}

print("First city with less than 5mil population: \(places[lessThan5I].name)")

guard let aI = places.firstIndex(withProperty: \.name, { $0.hasPrefix($1) }, "A") else {
  fatalError()
}

print("Population of first city starting with A: \(places[aI].population)")
