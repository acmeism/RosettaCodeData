class MyClass:
    name2 = 2 # Class attribute

    def __init__(self):
        """
        Constructor  (Technically an initializer rather than a true "constructor")
        """
        self.name1 = 0 # Instance attribute

    def someMethod(self):
        """
        Method
        """
        self.name1 = 1
        MyClass.name2 = 3


myclass = MyClass() # class name, invoked as a function is the constructor syntax.

class MyOtherClass:
    count = 0  # Population of "MyOtherClass" objects
    def __init__(self, name, gender="Male", age=None):
        """
        One initializer required, others are optional (with different defaults)
        """
        MyOtherClass.count += 1
        self.name = name
        self.gender = gender
        if age is not None:
            self.age = age
    def __del__(self):
        MyOtherClass.count -= 1

person1 = MyOtherClass("John")
print person1.name, person1.gender  # "John Male"
print person1.age                   # Raises AttributeError exception!
person2 = MyOtherClass("Jane", "Female", 23)
print person2.name, person2.gender, person2.age  # "Jane Female 23"
