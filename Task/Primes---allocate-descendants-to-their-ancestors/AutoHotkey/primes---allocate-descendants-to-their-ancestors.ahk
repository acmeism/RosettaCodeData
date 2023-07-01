#Warn
#SingleInstance force
#NoEnv            ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input    ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines, -1
SetFormat, IntegerFast, D

MaxPrime    = 99		; upper bound for the prime factors
MaxAncestor = 99		; greatest parent number

Descendants := []

Primes := GetPrimes(MaxPrime)
Exclusions := Primes.Clone()
Exclusions.Insert(4)

if A_Is64bitOS
{
	Loop, % MaxAncestor
		Descendants.Insert({})
	
	for i, Prime in Primes
	{
		Descendants[Prime, Prime] := 0
		
		for Parent, Children in Descendants
		{
			if ((Sum := Parent+Prime) > MaxAncestor)
				break
			
			for pr in Children
				Descendants[Sum, pr*Prime] := 0
		}
	}
	
	for i, v in Exclusions
		Descendants[v].Remove(v, "")
}
else
{
	Loop, % MaxAncestor
		Descendants.Insert([])

	for i, Prime in Primes
	{
		Descendants[Prime].Insert(Prime)
		
		for Parent, Children in Descendants
		{
			if ((Sum := Parent+Prime) > MaxAncestor)
				break
			
			for j, pr in Children
				Descendants[Sum].Insert(pr*Prime)
		}
	}
	
	for i, v in Exclusions
		Descendants[v].Remove()
}

if (MaxAncestor > MaxPrime)
	Primes := GetPrimes(MaxAncestor)

IfExist, %A_ScriptName%.txt
	FileDelete, %A_ScriptName%.txt

;-------------------------------------------------------
; Arrays :
; Integer keys are stored using the native integer type
; 32bit key max = 2.147.483.647
; 64bit key max = 9.223.372.036.854.775.807
;-------------------------------------------------------
Tot_desc = 0
for Parent, Children in Descendants
{
	ls_desc =
	if A_Is64bitOS
	{
		nb_desc = 0
		for pr in Children
			ls_desc .= ", " pr, nb_desc++
		ls_desc := LTrim(ls_desc, ", ")
	}
	else
	{
		nb_desc := Children.MaxIndex()
		for i, pr in Children
			ls_desc .= "," pr
		ls_desc := LTrim(ls_desc, ",")
		
		Sort, ls_desc, N D`,
		StringReplace, ls_desc, ls_desc, `,,`,%A_Space%, All
	}
	
	ls_anc =
	nb_anc := GetAncestors(ls_anc, Parent)
	ls_anc := LTrim(ls_anc, ", ")
	
	FileAppend, % "[" Parent "] Level: " nb_anc "`r`nAncestors: " (nb_anc ? ls_anc : "None") "`r`n"
				 , %A_ScriptName%.txt
	
	if nb_desc
	{
		Tot_desc += nb_desc
		FileAppend, % "Descendants: " nb_desc "`r`n" ls_desc "`r`n`r`n", %A_ScriptName%.txt
	}
	else
		FileAppend, % "Descendants: None`r`n`r`n", %A_ScriptName%.txt
}

FileAppend, % "Total descendants " Tot_desc, %A_ScriptName%.txt
return

GetAncestors(ByRef _lsAnc, _child)
{
	global Primes
	
	lChild := _child
	lIndex := lParent := 0
	
	while lChild > 1
	{
		lPrime := Primes[++lIndex]
		while !mod(lChild, lPrime)
			lChild //= lPrime, lParent += lPrime
	}
	
	if (lParent = _child or _child = 1)
		return 0
	
	_lsAnc := ", " lParent _lsAnc
	li := GetAncestors(_lsAnc, lParent)
	return ++li
}

GetPrimes(_maxPrime=0, _nbrPrime=0)
{
	lPrimes := []
	
	if (_maxPrime >= 2 or _nbrPrime >= 1)
	{
		lPrimes.Insert(2)
		lValue = 1
		
		while (lValue += 2) <= _maxPrime or lPrimes.MaxIndex() < _nbrPrime
		{
			lMaxPrime := Floor(Sqrt(lValue))
			
			for lKey, lPrime in lPrimes
			{
				if (lPrime > lMaxPrime)		; if prime divisor is greater than Floor(Sqrt(lValue))
				{
					lPrimes.Insert(lValue)
					break
				}
				
				if !Mod(lValue, lPrime)
					break
			}
		}
	}
	
	return lPrimes
}
