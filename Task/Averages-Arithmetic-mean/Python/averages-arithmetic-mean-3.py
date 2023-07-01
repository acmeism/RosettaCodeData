def average(x):
    return sum(x)/float(len(x)) if x else 0
print (average([0,0,3,1,4,1,5,9,0,0]))
print (average([1e20,-1e-20,3,1,4,1,5,9,-1e20,1e-20]))
