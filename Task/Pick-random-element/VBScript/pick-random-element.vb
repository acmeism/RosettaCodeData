Function pick_random(arr)
	Set objRandom = CreateObject("System.Random")
	pick_random = arr(objRandom.Next_2(0,UBound(arr)+1))
End Function

WScript.Echo pick_random(Array("a","b","c","d","e","f"))
