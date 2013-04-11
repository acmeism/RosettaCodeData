def sum_of_global_int_vars():
    variables = vars(__builtins__).copy()
    variables.update(globals())
    print sum(v for v in variables.itervalues() if type(v) == int)

sum_of_global_int_vars()
