function string:show ()
    print(self)
end

function string:append (s)
    self = self .. s
end

x = "Hi "
x:show()
x:append("there!")
x:show()
