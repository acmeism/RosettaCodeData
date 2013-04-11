from operator import itemgetter
people = [(120, 'joe'), (31, 'foo'), (51, 'bar')]
people.sort(key=itemgetter(0))
