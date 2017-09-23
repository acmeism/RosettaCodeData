my_file = open(filename, 'r')
try:
    for line in my_file:
        pass # process line, includes newline
finally:
    my_file.close()
