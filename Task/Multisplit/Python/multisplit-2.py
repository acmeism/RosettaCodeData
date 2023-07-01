def multisplit(text, sep):
    lastmatch = i = 0
    matches = []
    while i < len(text):
        for j, s in enumerate(sep):
            if text[i:].startswith(s):
                if i > lastmatch:
                    matches.append(text[lastmatch:i])
                matches.append((j, i))  # Replace the string containing the matched separator with a tuple of which separator and where in the string the match occured
                lastmatch = i + len(s)
                i += len(s)
                break
        else:
            i += 1
    if i > lastmatch:
        matches.append(text[lastmatch:i])
    return matches

>>> multisplit('a!===b=!=c', ['==', '!=', '='])
['a', (1, 1), (0, 3), 'b', (2, 6), (1, 7), 'c']
>>> multisplit('a!===b=!=c', ['!=', '==', '='])
['a', (0, 1), (1, 3), 'b', (2, 6), (0, 7), 'c']
