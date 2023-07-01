def avg(data):
    if len(data)==0:
        return 0
    else:
        return sum(data)/float(len(data))
print avg([0,0,3,1,4,1,5,9,0,0])
