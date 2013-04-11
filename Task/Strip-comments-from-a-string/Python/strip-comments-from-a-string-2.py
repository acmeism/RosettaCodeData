def remove_comments(line, sep):
    for s in sep:
        line = line.split(s)[0]
    return line.strip()

# test
print remove_comments('apples ; pears # and bananas', ';#')
print remove_comments('apples ; pears # and bananas', '!')
