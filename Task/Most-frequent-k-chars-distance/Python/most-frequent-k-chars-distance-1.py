import collections
def MostFreqKHashing(inputString, K):
    occuDict = collections.defaultdict(int)
    for c in inputString:
        occuDict[c] += 1
    occuList = sorted(occuDict.items(), key = lambda x: x[1], reverse = True)
    outputStr = ''.join(c + str(cnt) for c, cnt in occuList[:K])
    return outputStr

#If number of occurrence of the character is not more than 9
def MostFreqKSimilarity(inputStr1, inputStr2):
    similarity = 0
    for i in range(0, len(inputStr1), 2):
        c = inputStr1[i]
        cnt1 = int(inputStr1[i + 1])
        for j in range(0, len(inputStr2), 2):
            if inputStr2[j] == c:
                cnt2 = int(inputStr2[j + 1])
                similarity += cnt1 + cnt2
                break
    return similarity

def MostFreqKSDF(inputStr1, inputStr2, K, maxDistance):
    return maxDistance - MostFreqKSimilarity(MostFreqKHashing(inputStr1,K), MostFreqKHashing(inputStr2,K))
