result.each { println it.key; it.value.each {person -> println person} }

assert result.people[0].name == [family:'Flintstone', given:'Frederick']
assert result.people[4].age == 1
assert result.people[2].relationships.wife == 'people[3]'
assert result.people[3].name == [family:'Rubble', given:'Elisabeth']
assert Eval.x(result, 'x.' + result.people[2].relationships.wife + '.name') == [family:'Rubble', given:'Elisabeth']
assert Eval.x(result, 'x.' + result.people[1].relationships.husband + '.name') == [family:'Flintstone', given:'Frederick']
