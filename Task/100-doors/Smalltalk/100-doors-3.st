| m w h smh smw delay closedDoor border subMorphList |

closedDoor := Color black.
border := Color veryLightGray.
delay := Delay forMilliseconds: 50.
w := World bounds corner x.
h := (World bounds corner y) / 2.
smw := w/100.
smh := h/2.

m := BorderedMorph new position: 0@h.
m height: smh; width: w; borderColor: border.
m color: Color veryLightGray.

1 to: 100 do: [ :pos || sm |
	sm := BorderedMorph new height: smh ; width: smw ;
		borderColor: border; color: closedDoor;
		position: (smw*pos)@h.
	m addMorph: sm asElementNumber: pos].

m openInWorld.
delay wait.
subMorphList := m submorphs.
"display every step"
[1 to: 100 do: [ :step |
	step to: 100 by: step do: [ :pos | | subMorph |
		subMorph := subMorphList at: pos.
		subMorph color: subMorph color negated.
		delay wait]]] fork.
