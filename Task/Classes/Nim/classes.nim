type MyClass = object
  name: int

proc initMyClass(): MyClass =
  result.name = 2

proc someMethod(m: var MyClass) =
  m.name = 1

var mc = initMyClass()
mc.someMethod()

type
  Gender = enum male, female, other

  MyOtherClass = object
    name: string
    gender: Gender
    age: Natural

proc initMyOtherClass(name; gender = female; age = 50): auto =
  MyOtherClass(name: name, gender: gender, age: age)

var person1 = initMyOtherClass("Jane")
echo person1.name, " ", person1.gender, " ", person1.age # Jane female 50
var person2 = initMyOtherClass("John", male, 23)
echo person2.name, " ", person2.gender, " ", person2.age # John male 23
