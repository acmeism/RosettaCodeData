-- Incomplete code, just a sniplet to do the task. Can be used in any package or method.
-- Adjust the type of Year if you use a different one.
function Is_Leap_Year (Year : Integer) return Boolean is
begin
   if Year rem 100 = 0 then
      return Year rem 400 = 0;
   else
      return Year rem 4 = 0;
   end if;
end Is_Leap_Year;


-- An enhanced, more efficient version:
-- This version only does the 2 bit comparison (rem 4) if false.
-- It then checks rem 16 (a 4 bit comparison), and only if those are not
-- conclusive, calls rem 100, which is the most expensive operation.
-- I failed to be convinced of the accuracy of the algorithm at first,
-- so I rephrased it below.
-- FYI: 400 is evenly divisible by 16 whereas 100,200 and 300 are not. Ergo, the
-- set of integers evenly divisible by 16 and 100 are all evenly divisible by 400.
-- 1. If a year is not divisible by 4 => not a leap year. Skip other checks.
-- 2. If a year is evenly divisible by 16, it is either evenly divisible by 400 or
--    not evenly divisible by 100 => leap year. Skip further checks.
-- 3. If a year evenly divisible by 100 => not a leap year.
-- 4. Otherwise a leap year.

function Is_Leap_Year (Year : Integer) return Boolean is
begin
   return (Year rem 4 = 0) and then ((Year rem 16 = 0) or else (Year rem 100 /= 0));
end Is_Leap_Year;



-- To improve speed a bit more, use with
pragma Inline (Is_Leap_Year);
