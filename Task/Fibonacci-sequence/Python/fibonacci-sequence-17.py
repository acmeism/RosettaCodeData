fibseq = [1,1,]
fiblength = 21
for x in range(1,fiblength-1):
	xcount = fibseq[x-1] + fibseq[x]
	fibseq.append(xcount)
print(xcount)
