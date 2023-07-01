tritValues = .array~of(.trit~true, .trit~false, .trit~maybe)
tab = '09'x

say "not operation (\)"
loop a over tritValues
    say "\"a":" (\a)
end

say
say "and operation (&)"
loop aa over tritValues
    loop bb over tritValues
        say (aa" & "bb":" (aa&bb))
    end
end

say
say "or operation (|)"
loop aa over tritValues
    loop bb over tritValues
        say (aa" | "bb":" (aa|bb))
    end
end

say
say "implies operation (&&)"
loop aa over tritValues
    loop bb over tritValues
        say (aa" && "bb":" (aa&&bb))
    end
end

say
say "equals operation (=)"
loop aa over tritValues
    loop bb over tritValues
        say (aa" = "bb":" (aa=bb))
    end
end

::class trit
-- making this a private method so we can control the creation
-- of these.  We only allow 3 instances to exist
::method new class private
  forward class(super)

::method init class
  expose true false maybe
  -- delayed creation
  true = .nil
  false = .nil
  maybe = .nil

-- read only attribute access to the instances.
-- these methods create the appropriate singleton on the first call
::attribute true class get
  expose true
  if true == .nil then true = self~new("True")
  return true

::attribute false class get
  expose false
  if false == .nil then false = self~new("False")
  return false

::attribute maybe class get
  expose maybe
  if maybe == .nil then maybe = self~new("Maybe")
  return maybe

-- create an instance
::method init
  expose value
  use arg value

-- string method to return the value of the instance
::method string
  expose value
  return value

-- "and" method using the operator overload
::method "&"
  use strict arg other
  if self == .trit~true then return other
  else if self == .trit~maybe then do
      if other == .trit~false then return .trit~false
      else return .trit~maybe
  end
  else return .trit~false

-- "or" method using the operator overload
::method "|"
  use strict arg other
  if self == .trit~true then return .trit~true
  else if self == .trit~maybe then do
      if other == .trit~true then return .trit~true
      else return .trit~maybe
  end
  else return other

-- implies method...using the XOR operator for this
::method "&&"
  use strict arg other
  if self == .trit~true then return other
  else if self == .trit~maybe then do
      if other == .trit~true then return .trit~true
      else return .trit~maybe
  end
  else return .trit~true

-- "not" method using the operator overload
::method "\"
  if self == .trit~true then return .trit~false
  else if self == .trit~maybe then return .trit~maybe
  else return .trit~true

-- "equals" using the "=" override.  This makes a distinction between
-- the "==" operator, which is real equality and the "=" operator, which
-- is trinary equality.
::method "="
  use strict arg other
  if self == .trit~true then return other
  else if self == .trit~maybe then return .trit~maybe
  else return \other
