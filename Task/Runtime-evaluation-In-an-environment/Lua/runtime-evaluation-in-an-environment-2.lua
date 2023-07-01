env = {}
f = load("return x", nil, nil, env)
env.x = tonumber(io.read()) -- user enters 2
a = f()
env.x = tonumber(io.read()) -- user enters 3
b = f()
print(a + b) --> outputs 5
