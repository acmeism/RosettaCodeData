/*  Checking numbers from 0 to 10 */
for c = 0 to 10
	See checkmagic(c) + NL
next


/* The functions */

Func CheckMagic numb
	CardinalN = ""
	Result = ""
	if isnumber(numb) = false or numb < 0 or numb > 999_999_999_999_999
		Return "ERROR: Number entered is incorrect"
	ok
	if numb = 4
		Result = "Four is magic."
	else
		While True
			if CardinalN = "four"
				Result += "four is magic"
				exit
			ok
			strnumb = StringNumber(numb)
			CardinalN = StringNumber(len(strnumb))
			Result += strnumb + " is " + CardinalN + ", "
			numb = len(strnumb)
		End
		Result += "."
		Result = upper(Result[1]) + Right(Result, len(Result) -1)
	ok

	Return  Result

Func StringNumber cnumb

	NumStr = [:n0 = "zero", :n1 = "one", :n2 = "two", :n3 = "three", :n4 = "four", :n5 = "five",
		:n6 = "six", :n7 = "seven", :n8 = "eight", :n9 = "nine", :n10 = "ten",
		:n11 = "eleven", :n12 = "twelve", :n13 = "thirteen", :n14 = "fourteen", :n15 = "fifteen",
		:n16 = "sixteen", :n17 = "seventeen", :n18 = "eighteen", :n19 = "nineteen",
		:n20 = "twenty", :n30 = "thirty", :n40 = "fourty", :n50 = "fifty", :n60 = "sixty", :n70 = "seventy", :n80 = "eighty", :n90 = "ninety"]

	numLev = [:l1 = "", :l2 = "thousand", :l3 = "million", :l4 = "billion", :l5 = "trillion"]

	Result = ""

	if cnumb > 0
		decimals(0)
		snumb = string((cnumb))
		lnumb = [""]
		fl = floor(len(snumb) / 3)
		if fl > 0
			for i = 1 to  fl
				lnumb[i] = right(snumb, 3)
				snumb = left(snumb, len(snumb) -3)
				lnumb + ""
			next
			if (len(snumb) % 3) > 0
				lnumb[len(lnumb)] = snumb
			else
				del(lnumb, len(lnumb))
			ok
		else
			lnumb[1] = snumb
		ok
		for l = len(lnumb) to 1 step -1
			bnumb = lnumb[l]
			bResult = ""
			if number(bnumb) != 0
				for n = len(bnumb) to 1 step -1
					if (len(bnumb) = 3 and n = 2) or (len(bnumb) = 2 and n = 1)
						if number(bnumb[n]) > 1
							eval("bResult = NumStr[:n" + bnumb[n] + "0] + ' ' + bResult")
						elseif number(bnumb[n]) = 1
							eval("bResult = NumStr[:n" + bnumb[n] + bnumb[n+1] + "] + ' ' + bResult")
						ok
					else
						if len(bnumb) = 3 and n = 1 and number(bnumb[1]) > 0
							if trim(bResult) != ""
								bResult = " " + bResult
							ok
							if number(bnumb[1]) > 1
								bResult = "hundreds" + bResult
							else
								bResult = "hundred" + bResult
							ok
							if left(trim(bResult), 7) = "hundred"
								bResult = bResult + " "
							ok
						ok
						if (len(bnumb) = 3 and n = 1 and number(bnumb[1]) = 0) OR (len(bnumb) = n and number(bnumb[n]) = 0) OR (len(bnumb) = 3 and number(bnumb[2]) = 1) OR (len(bnumb) = 2 and number(bnumb[1]) = 1)
							loop
						ok
						eval("bResult = NumStr[:n" + bnumb[n] + "] + ' ' + bResult")
					ok
				next
				Result = Result + bResult
				if  l > 1
					if number(bnumb) > 1
						eval("Result = Result + numLev[:l" + l + "] + 's ' ")
					else
						eval("Result = Result + numLev[:l" + l + "] + ' ' ")
					ok
				ok
			ok
		next
	else
		Result = Result + NumStr[:n0]
	ok
	
Return trim(Result)
