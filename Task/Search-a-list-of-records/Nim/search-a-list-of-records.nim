template findIt(data, pred: untyped): int =
  ## Return the index of the first element in "data" satisfying
  ## the predicate "pred" or -1 if no such element is found.
  var result = -1
  for i, it {.inject.} in data.pairs:
    if pred:
      result = i
      break
  result


when isMainModule:

  import strutils

  type City = tuple[name: string; population: float]

  const Cities: seq[City] = @[("Lagos", 21.0),
                              ("Cairo", 15.2),
                              ("Kinshasa-Brazzaville", 11.3),
                              ("Greater Johannesburg", 7.55),
                              ("Mogadishu", 5.85),
                              ("Khartoum-Omdurman", 4.98),
                              ("Dar Es Salaam", 4.7),
                              ("Alexandria", 4.58),
                              ("Abidjan", 4.4),
                              ("Casablanca", 3.98)]

  echo "Index of the first city whose name is “Dar Es Salaam”: ",
      Cities.findIt(it.name == "Dar Es Salaam")

  let idx1 = Cities.findIt(it.population < 5)
  echo "Name of the first city whose population is less than 5 million: ",
      if idx1 == -1: "<none>" else: Cities[idx1].name

  let idx2 = Cities.findIt(it.name.startsWith("A"))
  echo "Population of the first city whose name starts with the letter “A”: ",
      if idx2 == -1: "<none>" else: $Cities[idx2].population
