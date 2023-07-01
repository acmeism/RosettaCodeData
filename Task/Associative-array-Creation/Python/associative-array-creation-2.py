# empty dictionary
d = {}
d['spam'] = 1
d['eggs'] = 2

# dictionaries with two keys
d1 = {'spam': 1, 'eggs': 2}
d2 = dict(spam=1, eggs=2)

# dictionaries from tuple list
d1 = dict([('spam', 1), ('eggs', 2)])
d2 = dict(zip(['spam', 'eggs'], [1, 2]))

# iterating over keys
for key in d:
  print key, d[key]

# iterating over (key, value) pairs
for key, value in d.iteritems():
  print key, value
