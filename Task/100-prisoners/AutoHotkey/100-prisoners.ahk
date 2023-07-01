NumOfTrials := 20000
randomFailTotal := 0, strategyFailTotal := 0
prisoners := [], drawers := [], Cards := []
loop, 100
	prisoners[A_Index] := A_Index				; create prisoners
	, drawers[A_Index] := true				; create drawers

loop, % NumOfTrials
{
	loop, 100
		Cards[A_Index] := A_Index			; create cards for this iteration
	loop, 100
	{
		Random, rnd, 1, Cards.count()
		drawers[A_Index] := Cards.RemoveAt(rnd)		; randomly place cards in drawers
	}
	;-------------------------------------------
	; randomly open drawers
	RandomList := []
	loop, 100
		RandomList[A_Index] := A_Index
	Fail := false
	while (A_Index <=100) && !Fail
	{
		thisPrisoner := A_Index
		res := ""
		while (thisCard <> thisPrisoner) && !Fail
		{
			Random, rnd, 1, % RandomList.Count()	; choose random number
			NextDrawer := RandomList.RemoveAt(rnd)	; remove drawer from random list (don't choose more than once)
			thisCard := drawers[NextDrawer]		; get card from this drawer
			if (A_Index > 50)
				Fail := true
		}
		if Fail
			randomFailTotal++
	}
	;-------------------------------------------
	; use optimal strategy
	Fail := false
	while (A_Index <=100) && !Fail
	{
		counter := 1, thisPrisoner := A_Index
		NextDrawer := drawers[thisPrisoner]		; 1st trial, drawer whose outside number is prisoner number
		while (drawers[NextDrawer] <> thisPrisoner) && !Fail
		{	
			NextDrawer := drawers[NextDrawer]	; drawer with the same number as that of the revealed card
			if ++counter > 50
				Fail := true
		}
		if Fail
			strategyFailTotal++
	}
}
MsgBox %  "Number Of Trials = " NumOfTrials
		. "`nOptimal Strategy:`t" (1 - strategyFailTotal/NumOfTrials) *100 " % success rate"
		. "`nRandom Trials:`t" (1 - randomFailTotal/NumOfTrials) *100 " % success rate"
