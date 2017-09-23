call dinnerTime "yogurt"
call dinnerTime .pizza~new
call dinnerTime .broccoli~new


-- a mixin class that defines the interface for being "food", and
-- thus expected to implement an "eat" method
::class food mixinclass object
::method eat abstract

::class pizza subclass food
::method eat
  Say "mmmmmmmm, pizza".

-- mixin classes can also be used for multiple inheritance
::class broccoli inherit food
::method eat
  Say "ugh, do I have to?".

::routine dinnerTime
  use arg dish
  -- ooRexx arguments are typeless, so tests for constrained
  -- types must be peformed at run time.  The isA method will
  -- check if an object is of the required type
  if \dish~isA(.food) then do
     say "I can't eat that!"
     return
  end
  else dish~eat
