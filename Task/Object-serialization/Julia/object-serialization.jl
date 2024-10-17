abstract type Hello end

struct HelloWorld <: Hello
    name::String
    HelloWorld(s) = new(s)
end

struct HelloTime <: Hello
    name::String
    tnew::DateTime
    HelloTime(s) = new(s, now())
end

sayhello(hlo) = println("Hello to this world, $(hlo.name)!")

sayhello(hlo::HelloTime) = println("It is now $(now()). Hello from back in $(hlo.tnew), $(hlo.name)!")

h1 = HelloWorld("world")
h2 = HelloTime("new world")

sayhello(h1)
sayhello(h2)

fh = open("objects.dat", "w")
serialize(fh, h1)
serialize(fh,h2)
close(fh)

sleep(10)

fh = open("objects.dat", "r")
hh1 = deserialize(fh)
hh2 = deserialize(fh)
close(fh)

sayhello(hh1)
sayhello(hh2)
