class Quitting(Exception): pass
max = 10
with open("some_file") as myfile:
    exit_counter = 0
    for line in myfile:
        exit_counter += 1
        if exit_counter > max:
            raise Quitting
        print line,
