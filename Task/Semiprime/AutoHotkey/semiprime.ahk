SetBatchLines -1
k := 1
loop, 100
{
	m := semiprime(k)
	StringSplit, m_m, m, -
		if ( m_m1 = "yes" )
			list .= k . " "
	k++
}
MsgBox % list
list :=
;===================================================================================================================================
k := 1675
loop, 5
{
	m := semiprime(k)
	StringSplit, m_m, m, -
		if ( m_m1 = "yes" )
			list1 .= semiprime(k) . "`n"
		else
			list1 .= semiprime(k) . "`n"
	k++
}
MsgBox % list1
list1 :=
;===================================================================================================================================
; The function==========================================================================================================================
semiprime(k)
{
		start := floor(sqrt(k))
				loop, % floor(sqrt(k)) - 1
					{
							if ( mod(k, start) = 0 )
								new .= floor(start) . "*" . floor(k//start) . ","
						start--
					}
		
		StringSplit, index, new, `,
		
			if ( index0 = 2 )
				{
					StringTrimRight, new, new, 1
					StringSplit, 2_ind, new, *
						if (mod(2_ind2, 2_ind1) = 0) && ( 2_ind1 != 2_ind2 )
							new := "N0- " . k . "  -  " . new
						else
							new := "yes- " . k . "  -  " . new
				}
			else
				new := "N0- " . k . "  -  " . new
return new
}
;=================================================================================================================================================
esc::Exitapp
