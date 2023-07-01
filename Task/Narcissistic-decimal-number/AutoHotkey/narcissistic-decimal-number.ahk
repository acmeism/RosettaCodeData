#NoEnv ; Do not try to use environment variables
SetBatchLines, -1 ; Execute as quickly as you can

StartCount := A_TickCount
Narc := Narc(25)
Elapsed := A_TickCount - StartCount

MsgBox, Finished in %Elapsed%ms`n%Narc%
return

Narc(m)
{
	Found := 0, Lower := 0
	Progress, B2
	Loop
	{
		Max := 10 ** Digits:=A_Index
		Loop, 10
			Index := A_Index-1, Powers%Index% := Index**Digits
		While Lower < Max
		{
			Sum := 0
			Loop, Parse, Lower
				Sum += Powers%A_LoopField%
			Loop, 10
			{
				
				if (Lower + (Index := A_Index-1) == Sum + Powers%Index%)
				{
					Out .= Lower+Index . (Mod(++Found,5) ? ", " : "`n")
					Progress, % Found/M*100
					if (Found >= m)
					{
						Progress, Off
						return Out
					}
				}
			}
			Lower += 10
		}
	}
}
