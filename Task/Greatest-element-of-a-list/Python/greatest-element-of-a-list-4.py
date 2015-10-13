>>> mylist = [47, 11, 42, 102, 13]
>>> reduce(lambda a,b: a if (a > b) else b, mylist)
102
