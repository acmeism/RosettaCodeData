function V3(x,y,z) return {x=x,y=y,z=z} end
function dot(v,w) return v.x*w.x + v.y*w.y + v.z*w.z end
function norm(v) local m=math.sqrt(dot(v,v)) return V3(v.x/m, v.y/m, v.z/m) end
function clamp(n,lo,hi) return math.floor(math.min(math.max(lo,n),hi)) end
function hittest(s, x, y)
  local z = s.r^2 - (x-s.x)^2 - (y-s.y)^2
  if z >= 0 then
    z = math.sqrt(z)
    return true, s.z-z, s.z+z
  end
  return false, 0, 0
end

function deathstar(pos, neg, sun, k, amb)
  shades = {[0]=" ",".",":","!","*","o","e","&","#","%","@"}
  for y = pos.x-pos.r-0.5, pos.x+pos.r+0.5 do
    for x = pos.x-pos.r-0.5, pos.x+pos.r+0.5, 0.5 do
      local hitpos, pz1, pz2 = hittest(pos, x, y)
      local result, hitneg, nz1, nz2 = 0
      if hitpos then
        hitneg, nz1, nz2 = hittest(neg, x, y)
        if not hitneg or nz1 > pz1 then result = 1
        elseif nz2 > pz2 then result = 0
        elseif nz2 > pz1 then result = 2
        else result = 1
        end
      end
      local shade = 0
      if result > 0 then
        if result == 1 then
          shade = clamp((1-dot(sun, norm(V3(x-pos.x, y-pos.y, pz1-pos.z)))^k+amb) * #shades, 1, #shades)
        else
          shade = clamp((1-dot(sun, norm(V3(neg.x-x, neg.y-y, neg.z-nz2)))^k+amb) * #shades, 1, #shades)
        end
      end
      io.write(shades[shade])
    end
    io.write("\n")
  end
end

deathstar({x=20, y=20, z=0, r=20}, {x=10, y=10, z=-15, r=10}, norm(V3(-2,1,3)), 2, 0.1)
