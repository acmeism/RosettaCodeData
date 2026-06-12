str1 = "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
str2 = "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"
K = 2
maxDistance = 100
dict1 = MostFreqKHashing(str1, 2)
print("%s:"%dict1)
print(''.join(c + str(cnt) for c, cnt in dict1.items()))
dict2 = MostFreqKHashing(str2, 2)
print("%s:"%dict2)
print(''.join(c + str(cnt) for c, cnt in dict2.items()))
print(MostFreqKSDF(str1, str2, K, maxDistance))
