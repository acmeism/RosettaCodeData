/* REXX ***************************************************************
* 30.07.2013 Walter Pachl as for REXX
**********************************************************************/
s=.list~of('Walter','lives','in','Vienna')
say listMax(s)
-- routine that will work with any ordered collection or sets and bags.
::routine listMax
  use arg list
  items=list~makearray   -- since we're dealing with different collection types, reduce to an array
  if items~isEmpty then return .nil   -- return a failure indicator.  could also raise an error, if desired
  largest = items[1]
  -- note, this method uses one extra comparison.  It could use
  -- do i = 2 to items~size to avoid this
  do item over items
     If item>>largest Then
       largest = item
  end
  return largest
