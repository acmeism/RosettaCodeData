use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

on run

  -- FIRST FIFTEEN RECAMANs ------------------------------------------------------

  script term15
    on |λ|(i)
      15 = (i as integer)
    end |λ|
  end script
  set strFirst15 to unwords(snd(recamanUpto(true, term15)))

  set strFirstMsg to "First 15 Recamans:" & linefeed
  display notification strFirstMsg & strFirst15
  delay 2

  -- FIRST DUPLICATE RECAMAN ----------------------------------------------------

  script firstDuplicate
    on |λ|(_, seen, rs)
      setSize(seen) as integer is not (length of (rs as list))
    end |λ|
  end script
  set strDuplicate to (item -1 of snd(recamanUpto(true, firstDuplicate))) as integer as string

  set strDupMsg to "First duplicated Recaman:" & linefeed
  display notification strDupMsg & strDuplicate
  delay 2

  -- NUMBER OF RECAMAN TERMS NEEDED TO GET ALL OF [0..1000]
  -- (takes about a minute, depending on system)

  set setK to setFromList(enumFromTo(0, 1000))
  script supersetK
    on |λ|(i, setR)
      setK's isSubsetOfSet:(setR)
    end |λ|
  end script

  display notification "Superset size result will take c. 1 min to find ..."
  set dteStart to current date

  set strSetSize to (fst(recamanUpto(false, supersetK)) - 1) as string

  set dteEnd to current date

  set strSetSizeMsg to "Number of Recaman terms needed to generate" & ¬
    linefeed & "all integers from [0..1000]:" & linefeed
  set strElapsed to "(Last result took c. " & (dteEnd - dteStart) & " seconds to find)"
  display notification strSetSizeMsg & linefeed & strSetSize

  -- CLEARED REFERENCE TO NSMUTABLESET -------------------------------------
  set setK to missing value

  -- REPORT ----------------------------------------------------------------
  unlines({strFirstMsg & strFirst15, "", ¬
    strDupMsg & strDuplicate, "", ¬
    strSetSizeMsg & strSetSize, "", ¬
    strElapsed})
end run

-- nextR :: Set Int -> Int -> Int
on nextR(seen, i, n)
  set bk to n - i
  if 0 > bk or setMember(bk, seen) then
    n + i
  else
    bk
  end if
end nextR

-- recamanUpto :: Bool -> (Int -> Set Int > [Int] -> Bool) -> (Int, [Int])
on recamanUpto(bln, p)
  script recaman
    property mp : mReturn(p)'s |λ|
    on |λ|()
      set i to 1
      set r to 0
      set rs to {r}
      set seen to setFromList(rs)
      repeat while not mp(i, seen, rs)
        set r to nextR(seen, i, r)
        setInsert(r, seen)
        if bln then set end of rs to r
        set i to i + 1
      end repeat
      set seen to missing value -- clear pointer to NSMutableSet
      {i, rs}
    end |λ|
  end script
  recaman's |λ|()
end recamanUpto

-- GENERIC FUNCTIONS -------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
  if m ≤ n then
    set lst to {}
    repeat with i from m to n
      set end of lst to i
    end repeat
    return lst
  else
    return {}
  end if
end enumFromTo

-- fst :: (a, b) -> a
on fst(tpl)
  if class of tpl is record then
    |1| of tpl
  else
    item 1 of tpl
  end if
end fst

-- intercalateS :: String -> [String] -> String
on intercalateS(sep, xs)
  set {dlm, my text item delimiters} to {my text item delimiters, sep}
  set s to xs as text
  set my text item delimiters to dlm
  return s
end intercalateS

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
  if class of f is script then
    f
  else
    script
      property |λ| : f
    end script
  end if
end mReturn

-- NB All names of NSMutableSets should be set to *missing value*
-- before the script exits.
-- ( scpt files containing residual ObjC pointer values can not be saved)
-- setFromList :: Ord a => [a] -> Set a
on setFromList(xs)
  set ca to current application
  ca's NSMutableSet's ¬
    setWithArray:(ca's NSArray's arrayWithArray:(xs))
end setFromList

-- setMember :: Ord a => a -> Set a -> Bool
on setMember(x, objcSet)
  missing value is not (objcSet's member:(x))
end setMember

-- setInsert :: Ord a => a -> Set a -> Set a
on setInsert(x, objcSet)
  objcSet's addObject:(x)
  objcSet
end setInsert

-- setSize :: Set a -> Int
on setSize(objcSet)
  objcSet's |count|() as integer
end setSize

-- snd :: (a, b) -> b
on snd(tpl)
  if class of tpl is record then
    |2| of tpl
  else
    item 2 of tpl
  end if
end snd

-- unlines :: [String] -> String
on unlines(xs)
  set {dlm, my text item delimiters} to ¬
    {my text item delimiters, linefeed}
  set str to xs as text
  set my text item delimiters to dlm
  str
end unlines

-- unwords :: [String] -> String
on unwords(xs)
  intercalateS(space, xs)
end unwords
