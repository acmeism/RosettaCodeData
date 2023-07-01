-- routine that will work with any ordered collection or sets and bags containing numbers.
::routine listMax
  use arg list
  items list~makearray   -- since we're dealing with different collection types, reduce to an array
  if items~isEmpty then return .nil   -- return a failure indicator.  could also raise an error, if desired
  largest = items[1]


  -- note, this method does call max one extra time.  This could also use the
  -- do i = 2 to items~size to avoid this
  do item over items
     largest = max(item, largest)
  end

  return largest
