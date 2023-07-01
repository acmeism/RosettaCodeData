import copy

class T:
   def classname(self):
      return self.__class__.__name__

   def __init__(self):
      self.myValue = "I'm a T."

   def speak(self):
      print self.classname(), 'Hello', self.myValue

   def clone(self):
      return copy.copy(self)

class S1(T):
   def speak(self):
      print self.classname(),"Meow", self.myValue

class S2(T):
   def speak(self):
      print self.classname(),"Woof", self.myValue


print "creating initial objects of types S1, S2, and T"
a = S1()
a.myValue = 'Green'
a.speak()

b = S2()
b.myValue = 'Blue'
b.speak()

u = T()
u.myValue = 'Purple'
u.speak()

print "Making copy of a as u, colors and types should match"
u = a.clone()
u.speak()
a.speak()
print "Assigning new color to u, A's color should be unchanged."
u.myValue = "Orange"
u.speak()
a.speak()

print "Assigning u to reference same object as b, colors and types should match"
u = b
u.speak()
b.speak()
print "Assigning new color to u. Since u,b references same object b's color changes as well"
u.myValue = "Yellow"
u.speak()
b.speak()
