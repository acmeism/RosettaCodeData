data =
(
44 Solomon
42 Jason
42 Errol
41 Garry
41 Bernard
41 Barry
39 Stephen
)

MsgBox, 262144, ,% ""
. "Standard Ranking:`n"		Rank(data)
. "`nModified Ranking:`n"	Rank(data, 2)
. "`nDense Ranking:`n" 		Rank(data, 3)
. "`nOrdinal Ranking:`n" 	Rank(data, 4)
. "`nFractional Ranking:`n"	Rank(data, 5)
return
