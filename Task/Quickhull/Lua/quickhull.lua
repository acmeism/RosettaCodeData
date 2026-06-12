-- QuickHull3D in Lua

local MAXN = 2500
local EPS  = 1e-8

-- Globals
local FAC = {}           -- list of facets
local pts = {}           -- points assigned to each facet
local TIME = 0
local e   = { {}, {} }   -- horizon edges: e[1][ptid], e[2][ptid]
local vistime = {}       -- per‐point visit timestamp
local queue = {}         -- facet queue
local resfnew, resfdel, respt = {}, {}, {}  -- temp lists

-- Initialize edge table and vistime
for k = 1,2 do
  e[k] = {}
  for i = 1, MAXN do
    e[k][i] = { netid = 0, facetid = 0 }
  end
end
for i = 1, MAXN do vistime[i] = 0 end

-- Vector class
local Vect = {}
Vect.__index = Vect
function Vect.new(x,y,z,id)
  return setmetatable({ x=x, y=y, z=z, id=id }, Vect)
end
function Vect:sub(o)
  return Vect.new(self.x-o.x, self.y-o.y, self.z-o.z, 0)
end
function Vect:cross(o)
  return Vect.new(
    self.y*o.z - self.z*o.y,
    self.z*o.x - self.x*o.z,
    self.x*o.y - self.y*o.x,
    0
  )
end
function Vect:dot(o)
  return self.x*o.x + self.y*o.y + self.z*o.z
end
function Vect:mag()
  return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end
function Vect:eq(o)
  local function eq(a,b) return math.abs(a-b)<EPS end
  return eq(self.x,o.x) and eq(self.y,o.y) and eq(self.z,o.z)
end

-- Line and Plane
local Line = {}
function Line.new(u,v) return { u=u, v=v } end

local Plane = {}
Plane.__index = Plane
function Plane.new(u,v,w)
  return setmetatable({ u=u, v=v, w=w }, Plane)
end
function Plane:normal()
  return self.v:sub(self.u):cross(self.w:sub(self.u))
end
function Plane:vecAt(i)
  -- i = 1,2,3
  if i==1 then return self.u
  elseif i==2 then return self.v
  else return self.w
  end
end
function Plane:vecId(i)
  return self:vecAt(i).id
end

-- Facet class
local Facet = {}
Facet.__index = Facet
function Facet.new()
  return setmetatable({ n={0,0,0}, id=0, vistime=0, isdel=false, p=Plane.new(nil,nil,nil) }, Facet)
end

-- Convex hull manager
local ConvexHulls3d = {}
ConvexHulls3d.__index = ConvexHulls3d
function ConvexHulls3d.new(idx)
  return setmetatable({ index=idx, surfacearea=0.0 }, ConvexHulls3d)
end

-- Utilities
local function gtr(a,b) return a-b>EPS end
local function ABS(x) return x<0 and -x or x end

-- Distances
local function distPointPlane(v,p)
  local n = p:normal()
  return (v:sub(p.u):dot(n)) / n:mag()
end
local function distPointLine(v,l)
  local d = v:sub(l.u):mag()
  if d==0 then return 0 end
  return l.v:sub(l.u):cross(v:sub(l.u)):mag() / l.v:sub(l.u):mag()
end
local function distPointPoint(a,b)
  return a:sub(b):mag()
end
local function isAbove(v,p)
  return gtr(v:sub(p.u):dot(p:normal()), 0)
end

-- Pre‐initialize
local function preConvexHulls()
  table.insert(pts,{})
  table.insert(FAC,Facet.new())  -- dummy at index 1
end

-- DFS for surface area
function ConvexHulls3d:dfsArea(fidx)
  local f = FAC[fidx]
  if f.vistime == TIME then return end
  f.vistime = TIME
  local n = f.p:normal()
  self.surfacearea = self.surfacearea + n:mag()/2
  for i=1,3 do self:dfsArea(f.n[i]) end
end

function ConvexHulls3d:getSurfaceArea()
  if self.surfacearea>0 then return self.surfacearea end
  TIME = TIME + 1
  self:dfsArea(self.index)
  return self.surfacearea
end

-- Find the horizon from facet fidx looking toward point p
function ConvexHulls3d:getHorizon(fidx,p,resfdel)
  local f = FAC[fidx]
  if not isAbove(p,f.p) then return 0 end
  if f.vistime==TIME then return -1 end
  f.vistime = TIME
  f.isdel = true
  table.insert(resfdel, fidx)
  local ret = -2
  for i=1,3 do
    local r = self:getHorizon(f.n[i], p, resfdel)
    if r==0 then
      local a = f.p:vecId(i)
      local b = f.p:vecId((i%3)+1)
      for j,pt in ipairs{a,b} do
        if vistime[pt]~=TIME then
          vistime[pt]=TIME
          e[1][pt] = { netid = (j==1 and b or a), facetid = f.n[i] }
        else
          e[2][pt] = { netid = (j==1 and b or a), facetid = f.n[i] }
        end
      end
      ret = a
    elseif r~=-1 and r~=-2 then
      ret = r
    end
  end
  return ret
end

-- Build initial tetrahedron
local function getStart(point, totp)
  -- pick 6 extremes
  local pt = {}
  for i=1,6 do pt[i]=point[1] end
  for i=1,totp do
    local v = point[i]
    if gtr(v.x,pt[1].x) then pt[1]=v end
    if gtr(pt[2].x,v.x) then pt[2]=v end
    if gtr(v.y,pt[3].y) then pt[3]=v end
    if gtr(pt[4].y,v.y) then pt[4]=v end
    if gtr(v.z,pt[5].z) then pt[5]=v end
    if gtr(pt[6].z,v.z) then pt[6]=v end
  end
  -- furthest pair
  local s = { pt[1], pt[2], point[1], point[1] }
  for i=1,6 do
    for j=i+1,6 do
      if gtr(distPointPoint(pt[i],pt[j]), distPointPoint(s[1],s[2])) then
        s[1],s[2]=pt[i],pt[j]
      end
    end
  end
  -- furthest from line
  local L = Line.new(s[1],s[2])
  s[3]=pt[1]
  for i=1,6 do
    if gtr(distPointLine(pt[i],L), distPointLine(s[3],L)) then
      s[3]=pt[i]
    end
  end
  -- furthest from plane
  s[4]=point[1]
  local base = Plane.new(s[1],s[2],s[3])
  for i=1,totp do
    if gtr(ABS(distPointPlane(point[i],base)), ABS(distPointPlane(s[4],base))) then
      s[4]=point[i]
    end
  end
  if gtr(0, distPointPlane(s[4],base)) then
    s[2],s[3]=s[3],s[2]
  end
  -- make 4 facets
  local fidx = {}
  for i=1,4 do
    local f = Facet.new()
    table.insert(FAC,f)
    f.id = #FAC
    fidx[i] = #FAC
  end
  FAC[fidx[1]].p = Plane.new(s[1],s[3],s[2])
  FAC[fidx[2]].p = Plane.new(s[1],s[2],s[4])
  FAC[fidx[3]].p = Plane.new(s[2],s[3],s[4])
  FAC[fidx[4]].p = Plane.new(s[3],s[1],s[4])
  -- neighbors
  FAC[fidx[1]].n = { fidx[4], fidx[3], fidx[2] }
  FAC[fidx[2]].n = { fidx[1], fidx[3], fidx[4] }
  FAC[fidx[3]].n = { fidx[1], fidx[4], fidx[2] }
  FAC[fidx[4]].n = { fidx[1], fidx[2], fidx[3] }
  -- prepare pts lists
  for i=1,4 do pts[fidx[i]] = {} end
  -- assign points above each face
  for i=1,totp do
    local v = point[i]
    if not (v:eq(s[1]) or v:eq(s[2]) or v:eq(s[3]) or v:eq(s[4])) then
      for j=1,4 do
        if isAbove(v,FAC[fidx[j]].p) then
          table.insert(pts[fidx[j]], v)
          break
        end
      end
    end
  end
  return ConvexHulls3d.new(fidx[1])
end

-- Main QuickHull3D
local function quickHull3d(point, totp)
  local hull = getStart(point, totp)
  -- init queue
  queue = { hull.index }
  for _,nbr in ipairs(FAC[hull.index].n) do
    table.insert(queue, nbr)
  end
  local snew = hull.index

  while #queue>0 do
    local nf = table.remove(queue,1)
    local face = FAC[nf]
    if face.isdel or #pts[nf]==0 then
      if not face.isdel then snew = nf end
    else
      -- farthest point from face
      local p = pts[nf][1]
      for i=2,#pts[nf] do
        local v = pts[nf][i]
        if gtr(distPointPlane(v,face.p), distPointPlane(p,face.p)) then
          p = v
        end
      end
      -- find horizon
      TIME = TIME + 1
      resfdel = {}
      local s = hull:getHorizon(nf, p, resfdel)

      -- build new faces around horizon
      resfnew = {}
      TIME = TIME + 1
      local from = -1
      local lastf, fstf = -1, -1
      while vistime[s] ~= TIME do
        vistime[s] = TIME
        local net, adj = 0,0
        if e[1][s].netid == from then
          net = e[2][s].netid; adj = e[2][s].facetid
        else
          net = e[1][s].netid; adj = e[1][s].facetid
        end
        -- find indices of s and net on face adj
        local pt1,pt2 = 1,1
        for i=1,3 do
          if point[s]:eq(FAC[adj].p:vecAt(i)) then pt1=i end
          if point[net]:eq(FAC[adj].p:vecAt(i)) then pt2=i end
        end
        if (pt1%3)+1 ~= pt2 then pt1,pt2 = pt2,pt1 end
        -- create new facet
        local nfnew = Facet.new()
        nfnew.p = Plane.new(FAC[adj].p:vecAt(pt2),
                            FAC[adj].p:vecAt(pt1), p)
        table.insert(FAC,nfnew)
        nfnew.id = #FAC
        table.insert(pts,{})
        table.insert(resfnew, nfnew.id)

        -- link adjacency
        nfnew.n[1] = adj
        FAC[adj].n[pt1] = nfnew.id
        if lastf~=-1 then
          local A1,A2 = nfnew.p:vecAt(2), FAC[lastf].p.u
          if A1:eq(A2) then
            nfnew.n[2], FAC[lastf].n[3] = lastf, nfnew.id
          else
            nfnew.n[3], FAC[lastf].n[2] = lastf, nfnew.id
          end
        else
          fstf = nfnew.id
        end
        lastf = nfnew.id
        from, s = s, net
      end

      -- close loop
      local A1,A2 = FAC[fstf].p:vecAt(2), FAC[lastf].p.u
      if A1:eq(A2) then
        FAC[fstf].n[2], FAC[lastf].n[3] = lastf, fstf
      else
        FAC[fstf].n[3], FAC[lastf].n[2] = lastf, fstf
      end

      -- collect deleted points
      respt = {}
      for _,fid in ipairs(resfdel) do
        for _,v in ipairs(pts[fid]) do
          table.insert(respt, v)
        end
        pts[fid] = {}
      end

      -- reassign
      for _,v in ipairs(respt) do
        if v~=p then
          for _,fid in ipairs(resfnew) do
            if isAbove(v,FAC[fid].p) then
              table.insert(pts[fid], v)
              break
            end
          end
        end
      end

      -- enqueue new faces
      for _,fid in ipairs(resfnew) do
        table.insert(queue, fid)
      end
    end
  end

  hull.index = snew
  return hull
end

-- Example usage
preConvexHulls()
local n = 4
local point = {}
local coords = {
  {0,0,0}, {1,0,0}, {0,1,0}, {0,0,1}
}
for i=1,n do
  local c = coords[i]
  point[i] = Vect.new(c[1],c[2],c[3], i)
end
local hull = quickHull3d(point, n)
print(string.format("%.3f", hull:getSurfaceArea()))
