/* Rexx */
-- --- Main --------------------------------------------------------------------
call demo
return
exit

-- -----------------------------------------------------------------------------
--  Shell sort implementation
-- -----------------------------------------------------------------------------
::routine shellSort
  use arg ra

  n = ra~items()
  inc = format(n / 2.0,, 0) -- rounding
  loop label inc while inc > 0
    loop i_ = inc to n - 1
      temp = ra~get(i_)
      j_ = i_
      loop label j_ while j_ >= inc
        if \(ra~get(j_ - inc) > temp) then leave j_
        ra~set(j_, ra~get(j_ - inc))
        j_ = j_ - inc
        end j_
      ra~set(j_, temp)
      end i_
    inc = format(inc / 2.2,, 0) -- rounding
    end inc

  return ra

-- -----------------------------------------------------------------------------
-- Demonstrate the implementation
-- -----------------------------------------------------------------------------
::routine demo

placesList = .nlist~of( -
    "UK  London",     "US  New York",   "US  Boston",     "US  Washington" -
  , "UK  Washington", "US  Birmingham", "UK  Birmingham", "UK  Boston"     -
)

lists = .array~of( -
    placesList -
  , shellSort(placesList~copy()) -
  )

loop ln = 1 to lists~items()
  cl = lists[ln]
  loop ct = 0 to cl~items() - 1
    say right(ct + 1, 4)':' cl[ct]
    end ct
    say
  end ln
  return

-- -----------------------------------------------------------------------------
::routine isTrue
  return 1 == 1

-- -----------------------------------------------------------------------------
::routine isFalse
  return \isTrue()

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
