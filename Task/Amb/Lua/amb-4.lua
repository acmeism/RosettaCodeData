print("Per task requirements:")
w1 = Amb('the','that','a')
w2 = Amb('frog','elephant','thing')
w3 = Amb('walked','treaded','grows')
w4 = Amb('slowly','quickly')
function rule(t) local a,b,c,d = unpack(t) return a:byte(#a)==b:byte(1) and b:byte(#b)==c:byte(1) and c:byte(#c)==d:byte(1) end
answers = Amb(rule, w1, w2, w3, w4)
answers:map(function(t) return t:concat(" ") end):each(print)

print()

print("Modified task, seek equal length of words:")
w1 = Amb('the','that','a','which')
w2 = Amb('red','green','blue','yellow')
w3 = Amb('frog','elephant','cow','thing')
w4 = Amb('walked','treaded','grew','shrunk')
w5 = Amb('slow','quick','moderately')
function rule(t) local a,b,c,d,e = unpack(t) return #a==#b and #b==#c and #c==#d and #d==#e end
answers = Amb(rule, w1, w2, w3, w4, w5)
answers:map(function(t) return t:concat(" ") end):each(print)

print()

print("Modified example, seek product of 12:")
x = Amb(1,2,3)
y = Amb(4,5,6)
function rule(t) local x,y = unpack(t) return x*y==12 end
answers = Amb(rule, x, y)
answers:map(function(t) return t:concat(" ") end):each(print)

print()

print("Pythagorean triples:")
x = Amb(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
y = Amb(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
z = Amb(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
function rule(t) local x,y,z = unpack(t) return x^2 + y^2 == z^2 end
answers = Amb(rule, x, y, z)
answers:map(function(t) return t:concat(" ") end):each(print)

print()

print("When there is no solution:")
x = Amb(1,2,3)
y = Amb(4,5,6)
function rule(t) local x,y = unpack(t) return x*y==7 end
answers = Amb(rule, x, y, z)
print("#answers = " .. #answers)

print()

print("send + more = money:")
-- intuitive simplification applied:  m must be 1 ==> others may not be 1 (reduces complexity from 10^8 to 9^7)
-- ("m is allowed to be leading zero" solutions exist, e.g. 2 8 1 7 0 3 6 5, and this could find them, but why?)
s = Amb(0,2,3,4,5,6,7,8,9)
e = Amb(0,2,3,4,5,6,7,8,9)
n = Amb(0,2,3,4,5,6,7,8,9)
d = Amb(0,2,3,4,5,6,7,8,9)
m = Amb(1)
o = Amb(0,2,3,4,5,6,7,8,9)
r = Amb(0,2,3,4,5,6,7,8,9)
y = Amb(0,2,3,4,5,6,7,8,9)
function rule(t)
  for i=1,#t do for j=i+1,#t do if t[i]==t[j] then return false end end end
  local s,e,n,d,m,o,r,y = unpack(t)
  return s*1000 + e*100 + 10*n + d + m*1000 + o*100 + r*10 + e == m*10000 + o*1000 + n*100 + e*10 + y
end
answers = Amb(rule, s, e, n, d, m, o, r, y)
answers:map(function(t) return t:concat(" ") end):each(print)
