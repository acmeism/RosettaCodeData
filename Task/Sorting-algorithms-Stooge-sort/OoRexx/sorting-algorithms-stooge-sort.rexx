/* Rexx */

call demo
return
exit

-- -----------------------------------------------------------------------------
--  Stooge sort implementation
-- -----------------------------------------------------------------------------
::routine stoogeSort
  use arg rL_, i_ = 0, j_ = .nil
  if j_ = .nil then j_ = rL_~items() - 1

  if rL_~get(j_) < rL_~get(i_) then do
    Lt = rL_~get(i_)
    rL_~set(i_, rL_~get(j_))
    rL_~set(j_, Lt)
    end
  if j_ - i_ > 1 then do
    t_ = (j_ - i_ + 1) % 3
    rL_ = stoogeSort(rL_, i_, j_ - t_)
    rL_ = stoogeSort(rL_, i_ + t_, j_)
    rL_ = stoogeSort(rL_, i_, j_ - t_)
    end

  return rL_

-- -----------------------------------------------------------------------------
-- Demonstrate the implementation
-- -----------------------------------------------------------------------------
::routine demo

  iList = .nlist~of(1, 4, 5, 3, -6, 3, 7, 10, -2, -5, 7, 5, 9, -3, 7)
  sList = iList~copy()

  placesList = .nlist~of( -
      "UK  London",     "US  New York",   "US  Boston",     "US  Washington" -
    , "UK  Washington", "US  Birmingham", "UK  Birmingham", "UK  Boston"     -
  )

  sList = stoogeSort(sList)
  sortedList = stoogeSort(placesList~copy())

  iLists = .list~of(iList, sList)
  loop ln = 0 to iLists~items() - 1
    icl = iLists[ln]
    rpt = ''
    loop ct = 0 to icl~items() - 1
      rpt = rpt icl[ct]
      end ct
      say '['rpt~strip()~changestr(' ', ',')']'
    end ln

  say
  sLists = .list~of(placesList, sortedList)
  loop ln = 0 to sLists~items() - 1
    scl = sLists[ln]
    loop ct = 0 to scl~items() - 1
      say right(ct + 1, 3)':' scl[ct]
      end ct
      say
    end ln

  return

-- -----------------------------------------------------------------------------
-- Helper class.  Map get and set methods for easier conversion from java.util.List
-- -----------------------------------------------------------------------------
::class NList mixinclass List public

-- Map get() to at()
::method get
  use arg ix
  return self~at(ix)

-- Map set() to put()
::method set
  use arg ix, item
  self~put(item, ix)
  return
