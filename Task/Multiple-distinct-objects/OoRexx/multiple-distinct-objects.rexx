-- get an array of directory objects
array = fillArrayWith(3, .directory)
say "each object will have a different identityHash"
say
loop d over array
    say d d~identityHash
end

::routine fillArrayWith
  use arg size, class

  array = .array~new(size)
  loop i = 1 to size
      -- Note, this assumes this object class can be created with
      -- no arguments
      array[i] = class~new
  end

return array
