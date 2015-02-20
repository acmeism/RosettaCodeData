SetBatchLines -1
Loop, 20000
{
	m := A_index

	; Getting factors
	loop % floor(sqrt(m))
	{
		if ( mod(m, A_index) = 0 )
		{	
			if ( A_index ** 2 == m )
			{
				sum += A_index
				continue
			} else if ( A_index != 1 )
			{
				sum += A_index + m//A_index
			} else if ( A_index = 1 )
			{
				sum += A_index
			}
		}
	} ; Factors obtained

	; Checking factors of sum
	if ( sum > 1 )
	{
		loop % floor(sqrt(sum))
		{
			if ( mod(sum, A_index) = 0 )
			{	
				if ( A_index ** 2 == sum )
				{
					sum2 += A_index
					continue
				} else if ( A_index != 1 )
				{
					sum2 += A_index + sum//A_index
				} else if ( A_index = 1 )
				{
					sum2 += A_index
				}
			}
		}		
		if ( m = sum2 ) && ( m != sum ) && ( m < sum )
			final .= m . ":" . sum . "`n"
	} ; Checked

	sum := 0
	sum2 := 0
}
MsgBox % final
ExitApp
