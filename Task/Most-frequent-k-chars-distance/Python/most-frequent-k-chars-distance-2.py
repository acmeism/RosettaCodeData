import collections
def MostFreqKHashing(inputString, K):
    occuDict = collections.defaultdict(int)
    for c in inputString:
        occuDict[c] += 1
    occuList = sorted(occuDict.items(), key = lambda x: x[1], reverse = True)
    outputDict = collections.OrderedDict(occuList[:K])
    #Return OrdredDict instead of string for faster lookup.
    return outputDict

def MostFreqKSimilarity(inputStr1, inputStr2):
    similarity = 0
    for c, cnt1 in inputStr1.items():
        #Reduce the time complexity of lookup operation to about O(1).
        if c in inputStr2:
            cnt2 = inputStr2[c]
            similarity += cnt1 + cnt2
    return similarity

def MostFreqKSDF(inputStr1, inputStr2, K, maxDistance):
    return maxDistance - MostFreqKSimilarity(MostFreqKHashing(inputStr1,K), MostFreqKHashing(inputStr2,K))
