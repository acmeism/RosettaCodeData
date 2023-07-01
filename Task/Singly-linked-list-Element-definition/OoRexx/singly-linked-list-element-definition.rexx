list = .linkedlist~new
index = list~insert("abc")   -- insert a first item, keeping the index
list~insert("def")           -- adds to the end
list~insert("123", .nil)     -- adds to the begining
list~insert("456", index)    -- inserts between "abc" and "def"
list~remove(index)           -- removes "abc"

say "Manual list traversal"
index = list~first           -- demonstrate traversal
loop while index \== .nil
    say index~value
    index = index~next
end

say
say "Do ... Over traversal"
do value over list
    say value
end

-- the main list item, holding the anchor to the links.
::class linkedlist
::method init
  expose anchor

  -- create this as an empty list
  anchor = .nil

-- return first link element
::method first
  expose anchor
  return anchor

-- return last link element
::method last
  expose anchor

  current = anchor
  loop while current \= .nil
      -- found the last one
      if current~next == .nil then return current
      current = current~next
  end
  -- empty
  return .nil

-- insert a value into the list, using the convention
-- followed by the built-in list class.  If the index item
-- is omitted, add to the end.  If the index item is .nil,
-- add to the end.  Otherwise, just chain to the provided link.
::method insert
  expose anchor
  use arg value

  newLink = .link~new(value)
  -- adding to the end
  if arg() == 1 then do
      if anchor == .nil then anchor = newLink
      else self~last~insert(newLink)
  end
  else do
      use arg ,index
      if index == .nil then do
         if anchor \== .nil then newLink~next = anchor
         anchor = newLink
      end
      else index~insert(newLink)
  end
  -- the link item serves as an "index"
  return newLink

-- remove a link from the chain
::method remove
  expose anchor

  use strict arg index

  -- handle the edge case
  if index == anchor then anchor = anchor~next
  else do
      -- no back link, so we need to scan
      previous = self~findPrevious(index)
      -- invalid index, don't return any item
      if previous == .nil then return .nil
      previous~next = index~next
  end
  -- belt-and-braces, remove the link and return the value
  index~next = .nil
  return index~value

-- private method to find a link predecessor
::method findPrevious private
  expose anchor
  use strict arg index

  -- we're our own precessor if this first
  if index == anchor then return self

  current = anchor
  loop while current \== .nil
      if current~next == index then return current
      current = current~next
  end
  -- not found
  return .nil

-- helper method to allow DO ... OVER traversal
::method makearray
  expose anchor
  array = .array~new

  current = anchor
  loop while current \= .nil
      array~append(current~value)
      current = current~next
  end
  return array

::class link
::method init
  expose value next
  -- by default, initialize both data and next to empty.
  use strict arg value = .nil, next = .nil

-- allow external access to value and next link
::attribute value
::attribute next

::method insert
  expose next
  use strict arg newNode
  newNode~next = next
  next = newNode
