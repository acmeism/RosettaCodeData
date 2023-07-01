24Game
	k number, operator, bracket
	; generate 4 random numbers each between 1 & 9
	; duplicates allowed!
	s n1=$r(9)+1, n2=$r(9)+1, n3=$r(9)+1, n4=$r(9)+1
	; save a copy of them so that we can keep restarting
	; if the user gets it wrong
	s s1=n1,s2=n2,s3=n3,s4=n4
Question
	s (numcount,opcount,lbrackcount,rbrackcount)=0
	; restart with the random numbers already found
	s n1=s1,n2=s2,n3=s3,n4=s4
	w !,"Enter an arithmetic expression that evaluates to 24 using (",
	n1," ",n2," ",n3," ",n4,"): "
	r !,expr
	q:expr=""
	; validate numbers and operators
	s error=""
	f n=1:1:$l(expr) {
		s char=$e(expr,n)
		if char?1n {
			s number($i(numcount))=char
			w !
			zw char
		}
		elseif char?1(1"*",1"/",1"+",1"-") {
			s operator($i(opcount))=char
		}
		elseif char?1"(" {
			s bracket($i(lbrackcount))=char
		}
		elseif char?1")" {
			s bracket($i(rbrackcount))=char
		}
		else {
			s error="That ain't no character I wanted to see"
			q
		}
	}
	if error'="" w error g Question
	if numcount'=4 {
		w "Does not have 4 numbers, do it again."
		g Question
	}
	s error=""
	f n=1:1:4 {
		if number(n)=n1 {
			s n1="dont use again" continue
		}
		if number(n)=n2 {
			s n2="dont use again" continue
		}
		if number(n)=n3 {
			s n3="dont use again" continue
		}
		if number(n)=n4 {
			s n4="dont use again" continue
		}
		s error="Numbers entered do not match all of the randomly generated numbers."
		q
	}
	if error'="" {
		w error
		g Question
	}
	if opcount'=3 {
		w "Does not have 3 operators."
		g Question
	}
	if lbrackcount'=rbrackcount {
		w "brackets must be in pairs."
		g Question
	}
	x "s x="_expr
	if x'=24 {
		w !,"Answer does not = 24"
		g Question
	}
	w x
	q
