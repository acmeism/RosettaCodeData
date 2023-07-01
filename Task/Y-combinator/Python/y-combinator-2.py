Y = lambda f: lambda *args: f(Y(f))(*args)
