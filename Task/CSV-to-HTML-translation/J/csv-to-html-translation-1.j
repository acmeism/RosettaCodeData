require 'strings tables/csv'
encodeHTML=: ('&';'&amp;';'<';'&lt;';'>';'&gt;')&stringreplace

tag=: adverb define
  'starttag endtag'=.m
  (,&.>/)"1 (starttag , ,&endtag) L:0 y
)

markupCells=:    ('<td>';'</td>') tag
markupHdrCells=: ('<th>';'</th>') tag
markupRows=:     ('<tr>';'</tr>',LF) tag
markupTable=:    (('<table>',LF);'</table>') tag

makeHTMLtablefromCSV=: verb define
  0 makeHTMLtablefromCSV y             NB. default left arg is 0 (no header row)
:
  t=. fixcsv encodeHTML y
  if. x do. t=. (markupHdrCells@{. , markupCells@}.) t
      else. t=. markupCells t
  end.
  ;markupTable markupRows t
)
