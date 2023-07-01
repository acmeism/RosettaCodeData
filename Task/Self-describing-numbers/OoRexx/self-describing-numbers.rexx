-- REXX program to check if a number (base 10) is self-describing.
parse arg x y .
if x=='' then exit
if y=='' then y=x
-- 10 digits is the maximum size number that works here, so cap it
numeric digits 10
y=min(y, 9999999999)

loop number = x to y
  loop i = 1 to number~length
      digit = number~subchar(i)
      -- return on first failure
      if digit \= number~countstr(i - 1) then iterate number
   end
   say number "is a self describing number"
end
