local object = { name = "foo", func = function (self) print(self.name) end }

object:func() -- with : sugar
object.func(object) -- without : sugar
