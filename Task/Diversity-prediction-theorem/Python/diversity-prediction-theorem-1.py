def mean(lst):
    return sum(lst)/len(lst)

def squarediffs(x, lst):
    return [(x-y)**2 for y in lst]

def diversityprediction(obs, ests):
    print("True value:", obs)
    print("Estimates:", *ests)
    print("Average error:", mean(squarediffs(obs, ests)))
    print("Crowd error:", (obs-mean(ests))**2)
    print("Prediction diversity:", mean(squarediffs(mean(ests), ests)))

diversityprediction(49, [48, 47, 51])
diversityprediction(49, [48, 47, 51, 42])
