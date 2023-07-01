Class = {
  classname = "Class aka Object aka Root-Of-Tree",
  new = function(s,t)
    s.__index = s
    local instance = setmetatable(t or {}, s)
    instance.parent = s
    return instance
  end
}

Animal = Class:new{classname="Animal", speak=function(s) return s.voice or "("..s.classname.." has no voice)" end }
Cat = Animal:new{classname="Cat", voice="meow"}
Dog = Animal:new{classname="Dog", voice="woof"}
Lab = Dog:new{classname="Lab", voice="bark"}
Collie = Dog:new{classname="Collie"}  -- subclass without a unique voice

print("Animal:speak():  " .. Animal:speak())
print("Cat:speak():  " .. Cat:speak())
print("Dog:speak():  " .. Dog:speak())
print("Lab:speak():  " .. Lab:speak())
print("Collie:speak():  " .. Collie:speak())

max = Collie:new{voice="Hi, I am Max the talking Collie!"} -- instance with a unique voice
print("max:speak():  " .. max:speak())
print("max himself is (instance):  " .. max.classname)
print("max's parent is (class):  " .. max.parent.classname)
print("max's parent's parent is (class):  " .. max.parent.parent.classname)
print("max's parent's parent's parent is (class):  " .. max.parent.parent.parent.classname)
print("max's parent's parent's parent's parent is (class):  " .. max.parent.parent.parent.parent.classname)
print("max's parent's parent's parent's parent's parent is (nil reference):  " .. tostring(max.parent.parent.parent.parent.parent))
