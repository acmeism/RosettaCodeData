a = 5
b = "hello"

print(isinstance(a, int | str))
print(isinstance(a, float | str))
print(isinstance(b, float | int))
print(isinstance(b, str | int))
