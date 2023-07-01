db =
(
Display an outline as a nested table.
	Parse the outline to a tree,
		measuring the indent of each line,
		translating the indentation to a nested structure,
		and padding the tree to even depth.
	count the leaves descending from each node,
		defining the width of a leaf as 1,
		and the width of a parent node as a sum.
			(The sum of the widths of its children)
	and write out a table with 'colspan' values
		either as a wiki table,
		or as HTML.
)

Gui, add, ActiveX, vDocument w1000 r14, HTMLFile
result := outline2table(db)
Document.Write(result.1)
Gui, Show
MsgBox % "HTML:`n" result.1 "`n`nWikitable:`n" result.2
return
