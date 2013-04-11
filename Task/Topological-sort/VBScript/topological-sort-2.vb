dim toposort
set toposort = new topological
toposort.dependencies = "des_system_lib	std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee" & vbNewLine & _
	"dw01	ieee dw01 dware gtech" & vbNewLine & _
	"dw02	ieee dw02 dware" & vbNewLine & _
	"dw03	std synopsys dware dw03 dw02 dw01 ieee gtech" & vbNewLine & _
	"dw04	dw04 ieee dw01 dware gtech" & vbNewLine & _
	"dw05	dw05 ieee dware" & vbNewLine & _
	"dw06	dw06 ieee dware" & vbNewLine & _
	"dw07	ieee dware" & vbNewLine & _
	"dware	ieee dware" & vbNewLine & _
	"gtech	ieee gtech" & vbNewLine & _
	"ramlib	std ieee" & vbNewLine & _
	"std_cell_lib	ieee std_cell_lib" & vbNewLine & _
	"synopsys	"

dim k
for each k in toposort.keys
	wscript.echo "----- " & k
	toposort.resolve k
	wscript.echo "-----"
	toposort.reset
next
