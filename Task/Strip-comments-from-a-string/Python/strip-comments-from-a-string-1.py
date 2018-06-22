def remove_comments(line, sep):
    for s in sep:
        i = line.find(s)
        if i >= 0:
            line = line[:i]
    return line.strip()

# test
print remove_comments('apples ; pears # and bananas', ';#')
print remove_comments('apples ; pears # and bananas', '!')
