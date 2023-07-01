def min_pos(List):
	return List.index(min(List))

def find_all(S, Sub, Start = 0, End = -1, IsOverlapped = 0):
	Res = []
	if End == -1:
		End = len(S)
	if IsOverlapped:
		DeltaPos = 1
	else:
		DeltaPos = len(Sub)
	Pos = Start
	while True:
		Pos = S.find(Sub, Pos, End)
		if Pos == -1:
			break
		Res.append(Pos)
		Pos += DeltaPos
	return Res

def multisplit(S, SepList):
	SepPosListList = []
	SLen = len(S)
	SepNumList = []
	ListCount = 0
	for i, Sep in enumerate(SepList):
		SepPosList = find_all(S, Sep, 0, SLen, IsOverlapped = 1)
		if SepPosList != []:
			SepNumList.append(i)
			SepPosListList.append(SepPosList)
			ListCount += 1
	if ListCount == 0:
		return [S]
	MinPosList = []
	for i in range(ListCount):
		MinPosList.append(SepPosListList[i][0])
	SepEnd = 0
	MinPosPos = min_pos(MinPosList)
	Res = []
	while True:
		Res.append( S[SepEnd : MinPosList[MinPosPos]] )
		Res.append([SepNumList[MinPosPos], MinPosList[MinPosPos]])
		SepEnd = MinPosList[MinPosPos] + len(SepList[SepNumList[MinPosPos]])
		while True:
			MinPosPos = min_pos(MinPosList)
			if MinPosList[MinPosPos] < SepEnd:
				del SepPosListList[MinPosPos][0]
				if len(SepPosListList[MinPosPos]) == 0:
					del SepPosListList[MinPosPos]
					del MinPosList[MinPosPos]
					del SepNumList[MinPosPos]
					ListCount -= 1
					if ListCount == 0:
						break
				else:
					MinPosList[MinPosPos] = SepPosListList[MinPosPos][0]
			else:
				break
		if ListCount == 0:
			break
	Res.append(S[SepEnd:])
	return Res


S = "a!===b=!=c"
multisplit(S, ["==", "!=", "="]) # output: ['a', [1, 1], '', [0, 3], 'b', [2, 6], '', [1, 7], 'c']
multisplit(S, ["=", "!=", "=="]) # output: ['a', [1, 1], '', [0, 3], '', [0, 4], 'b', [0, 6], '', [1, 7], 'c']
