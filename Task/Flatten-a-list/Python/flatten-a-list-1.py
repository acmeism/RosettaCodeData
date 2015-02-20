>>> def flatten(lst, results=[]):      # 'results' defaults to an empty list []
        for e in lst:                  #   for each element 'e' in lst
            if type(e) is list:        #      if that element is a list, then
                flatten(e, results)    #         flatten that sublist, appending results to "results"
            else:                      #      if element is not a list, then
                results.append(e)      #         insert a copy of it at the end of "results"
        return results

>>> l = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]
>>> flatten(l)
[1, 2, 3, 4, 5, 6, 7, 8]
