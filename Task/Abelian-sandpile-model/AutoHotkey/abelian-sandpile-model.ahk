Size := Size2 := 10
celula := [], Deltas := ["-1,0","1,1","0,-1","0,1"], Width := Size * 2.5
Gui, font, S%Size%
Gui, add, text, y1
loop, 19
{
	Row := A_Index
	loop, 19
	{
		Col := A_Index
		Gui, add, button, % (Col=1 ? "xs y+1" : "x+1 yp") " v" Col "_" Row " w" Width " -TabStop"
		celula[Col,Row] := 0
		GuiControl, hide, %Col%_%Row%
	}
}
gui, color, black
Gui, show,, Abelian SandPile
InputBox, areia,, How much particles?,, 140, 140
celula[10,10] := areia
inicio:
loop
{
GuiControl,, 10_10, % celula[10,10]
fim := true
loop 19
	{
		linha := A_Index
		loop 19
		{
			coluna := A_Index
			if (celula[coluna,linha] >= 4)
				{
					celula[coluna,linha] -= 4
					celula[coluna-1,linha] += 1
					celula[coluna+1,linha] += 1
					celula[coluna,linha-1] += 1
					celula[coluna,linha+1] += 1
					fim := false
				}
		}
	}
if (fim = true)
	break
}
loop 19
	{
		line := A_Index
		loop 19
			{
				column := A_Index
				GuiControlGet, posicao, Pos, % column "_" line
				switch celula[column,line]
					{
						case 0:
							gui, add, progress, Backgroundblue w24 h24 x%posicaoX% y%posicaoY%
						case 1:
							gui, add, progress, backgroundred w24 h24 x%posicaoX% y%posicaoY%
						case 2:
							gui, add, progress, backgroundgreen w24 h24 x%posicaoX% y%posicaoY%
						case 3:
							gui, add, progress, backgroundyellow w24 h24 x%posicaoX% y%posicaoY%
					}
			}
	}
msgbox sair
ExitApp
