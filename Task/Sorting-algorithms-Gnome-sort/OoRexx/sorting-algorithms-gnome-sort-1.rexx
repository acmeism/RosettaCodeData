/* Rexx */

call demo
return
exit

-- -----------------------------------------------------------------------------
--  Gnome sort implementation
-- -----------------------------------------------------------------------------
::routine gnomeSort
  use arg ra, sAsc = ''
  if sAsc = '' then sAsc = isTrue()

  sDsc = \sAsc -- Ascending/descending switches
  i_ = 1
  j_ = 2
  loop label i_ while i_ < ra~items()
    ctx = (ra~get(i_ - 1))~compareTo(ra~get(i_))
    if (sAsc & ctx <= 0) | (sDsc & ctx >= 0) then do
      i_ = j_
      j_ = j_ + 1
      end
    else do
      swap = ra~get(i_)
      ra~set(i_, ra~get(i_ - 1))
      ra~set(i_ - 1, swap)
      i_ = i_ - 1
      if i_ = 0 then do
        i_ = j_
        j_ = j_ + 1
        end
      end
    end i_

  return ra

-- -----------------------------------------------------------------------------
-- Demonstrate the implementation
-- -----------------------------------------------------------------------------
::routine demo
  placesList = .nlist~of( -
      "UK  London",     "US  New York",   "US  Boston",     "US  Washington" -
    , "UK  Washington", "US  Birmingham", "UK  Birmingham", "UK  Boston"     -
  )

  lists = .nlist~of( -
      placesList -
    , gnomeSort(placesList~copy()) -
  )

  loop ln = 0 to lists~items() - 1
    cl = lists[ln]
    loop ct = 0 to cl~items() - 1
      say right(ct + 1, 3)':' cl[ct]
      end ct
    say
    end ln

  i_.0 = 3
  i_.1 = .nlist~of(3, 3, 1, 2, 4, 3, 5, 6)
  i_.2 = gnomeSort(i_.1~copy(), isTrue())
  i_.3 = gnomeSort(i_.1~copy(), isFalse())
  loop s_ = 1 to i_.0
    ss = ''
    loop x_ = 0 to i_.s_~items() - 1
      ss ||= right(i_.s_~get(x_), 3)' '
      end x_
    say strip(ss, 'T')
    end s_

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
