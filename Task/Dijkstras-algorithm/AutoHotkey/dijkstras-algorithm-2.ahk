data =
(
A	B	7
A	C	9
A	F	14
B	C	10
B	D	15
C	D	11
C	F	2
D	E	6
E	F	9
)

nodes:=[], Distance := []
for each, line in StrSplit(data, "`n" , "`r")
    field := StrSplit(line,"`t"), nodes[field.1] := 1, nodes[field.2] := 1
    , Distance[field.1,field.2] := field.3  , Distance[field.2,field.1] := field.3

for node, v in nodes
    nodeList .= (nodeList?"|":"") node (A_Index=1?"|":"")

Gui, add, Text,, From:
Gui, add, Text, x200 yp, To:
Gui, add, DDL, xs vFrom gSubmit, % nodeList
Gui, add, DDL, x200 yp vTo gSubmit, % nodeList
Gui, add, ListView, xs w340 r6, From|>|To|Distance
Gui, add, Text, vT1 xs w340 r1
Gui, +AlwaysOnTop
Gui, show
Loop 4
	LV_ModifyCol(A_Index, "80 Center")

Submit:
Gui, Submit, NoHide
GuiControl, , T1, % ""
LV_Delete()
if !(From && To) || (From = To)
    return
res := Dijkstra(data, From)	, 	xTo := xFrom := DirectFlight := "" , origin := to
GuiControl, , T1, no routing found
if !res[1, To]              ; no possible route
    return

Routing:
Loop % objCount(nodes)
    for xTo , xFrom in res.2
        if (xTo = To)
        {
			LV_Insert(1,"", xFrom, ">" , xTo, Distance[xFrom , xTo]),	To := xFrom
            if (xFrom = From)
                break, Routing
        }
GuiControl, , T1, % "Total distance = " res.1[origin] . DirectFlight
return

esc::
GuiClose:
ExitApp
return
