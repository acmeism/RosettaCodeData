<Cfset theList = '1, 1000, 250, 13'>
<Cfset maxNum = ListFirst(ListSort(thelist, "numeric", "desc"))>
<Cfoutput>#maxNum#</Cfoutput>
