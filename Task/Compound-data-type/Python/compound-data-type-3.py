class MyObject(object): pass
point = MyObject()
point.x, point.y = 0, 1
# objects directly instantiated from "object()"  cannot be "monkey patched"
# however this can generally be done to it's subclasses
