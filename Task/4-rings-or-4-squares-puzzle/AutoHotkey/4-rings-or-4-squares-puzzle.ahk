rotina(min,max,unique)
{
global totalcount := 0
global totalunique := 0
global result := "min=" min " max=" max " unique=" unique "`n`n"
max := max - min + 1
loop %max%
{
	a := min + A_Index - 1
	loop %max%
	{
		b := min + A_Index - 1
		loop %max%
		{
			c := min + A_Index - 1
			loop %max%
			{
				d := min + A_Index - 1
				loop %max%
				{
					e := min + A_Index - 1
					loop %max%
					{
						f := min + A_Index - 1
						loop %max%
						{
							g := min + A_Index - 1
							sum := a+b
							if (b+c+d = sum and d+e+f = sum and f+g = sum)
							{
								totalcount += 1
								if (unique=0)
									continue
								if not (a=b or a=c or a=d or a=e or a=f or a=g or b=c or b=d or b=e or b=f or b=g or c=d or c=e or c=f or c=g or d=e or d=f or d=g or e=f or e=g or f=g)
									{
										result .= a " " b " " c " " d " " e " " f " " g "`n"
										totalunique += 1
									}	
							}
						}
					}
				}
			}
		}
	}
}
}
rotina(1,7,1)
MsgBox %result% `ntotal unique = %totalunique% `ntotalcount = %totalcount%
rotina(3,9,1)
MsgBox %result% `ntotal unique = %totalunique% `ntotalcount = %totalcount%
rotina(0,9,0)
MsgBox %result% `ntotalcount = %totalcount%
ExitApp
return
