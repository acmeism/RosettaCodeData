person: make object! [
  name: none
  age:  none
]

people: reduce [make person [name: "fred" age: 20] make person [name: "paul" age: 21]]
people/1: make people/1 [skill: "fishing"]

foreach person people [
  print reduce [person/age "year old" person/name "is good at" any [select person 'skill "nothing"]]
]
