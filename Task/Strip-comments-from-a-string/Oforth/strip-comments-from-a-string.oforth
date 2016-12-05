: stripComments(s, markers)
| firstMarker |
   markers map(#[ s indexOf ]) reduce(#min) ->firstMarker
   s firstMarker ifNotNull: [ left(firstMarker 1 - ) ] strip ;
