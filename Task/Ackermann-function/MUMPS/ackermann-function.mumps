Ackermann(m,n)	;
	If m=0 Quit n+1
	If m>0,n=0 Quit $$Ackermann(m-1,1)
	If m>0,n>0 Quit $$Ackermann(m-1,$$Ackermann(m,n-1))
	Set $Ecode=",U13-Invalid parameter for Ackermann: m="_m_", n="_n_","

Write $$Ackermann(1,8) ; 10
Write $$Ackermann(2,8) ; 19
Write $$Ackermann(3,5) ; 253
