-- Super-d numbers - translated from the EasyLang sample

local function bnmul( a, b ) -- multiply the base 1000000 number in a by b
   local c, r = 0, {}        -- the most significant digits are in a[ # a ]
   for _, d in ipairs( a ) do
      local h = c + d * b
      table.insert( r, h % 10000000 )
      c = math.floor(  h / 10000000 )
   end
   if c > 0 then table.insert( r, c ) end
   for i, d in ipairs( r ) do a[ i ] = d end
end
local function str( bn ) -- convert the base 1000000 number in bn to a string
   local s = tostring( bn[ # bn ] ) -- no need to 0 pad the most significant digits
   for i = # bn - 1, 1, -1 do       -- less significant digits must be 0-padded
      local h = tostring( bn[ i ] )
      s = s .. string.sub( "0000000", 1, ( 7 - # h ) ) .. h
   end
   return s
end
local function superd( d ) -- return the super-d numbers
   local n, found, dds = 0, {}, string.rep( tostring( d ), d )
   while # found < 10 do
      local dnd = { 1 }
      for i = 1, d do bnmul( dnd, n ) end
      bnmul( dnd, d )
      if string.find( str( dnd ), dds, 1, true ) then
         table.insert( found, n )
      end
      n = n + 1
   end
   return found
end
for i = 2, 7 do
   print( i .. ": " .. table.concat( superd( i ), " " ) )
end
