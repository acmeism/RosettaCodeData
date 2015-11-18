>>> myMean = lambda MyList : reduce(lambda x, y: x + y, MyList) / float(len(MyList))
>>> myStd = lambda MyList : (reduce(lambda x,y : x + y , map(lambda x: (x-myMean(MyList))**2 , MyList)) / float(len(MyList)))**.5

>>> print myStd([2,4,4,4,5,5,7,9])
2.0
