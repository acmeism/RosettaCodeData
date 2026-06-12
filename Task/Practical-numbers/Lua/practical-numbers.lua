local function make_divisors( n )
   local divs = { 1 }
   for i = 2, math.floor( n / 2 ) do
      if n % i == 0 then table.insert( divs, i ) end
   end
   return divs
end
local function sum_divisors( n, divs )
   local term, sum = 1, 0
   while n > 0 do
      if n % 2 == 1 then sum = sum + divs[ term ] end
      term = term + 1
      n = math.floor( n / 2 )
   end
   return sum
end
local function is_practical( n )
   if n == 1 then return 1 end
   if n % 2 == 1 then return 0 end
   if n < 5 then return 1 end
   local hits = {}
   for i = 1, n - 1 do hits[ i ] = 0 end
   local divs = make_divisors( n )
   local nt = # divs
   for i = 1, ( 2 ^ nt ) - 1 do
      local sd = sum_divisors( i, divs )
      if sd < n then hits[ sd ] = hits[ sd ] + 1 end
   end
   for i = 1, n - 1 do
      if hits[ i ] == 0 then return 0 end
   end
   return 1
end

io.write( "  1 " )
local pCount = 1
for n = 2, 333 do
   if is_practical( n ) == 1 then
       pCount = pCount + 1
       io.write( string.format( "%3d%s", n, ( pCount % 10 == 0 and "\n" or " " ) ) )
   end
end
print()
print( "666 "..( is_practical( 666 ) == 1 and "is" or "is not" ).." a practical number" )
