local function load_data(npoints, radius)
  -- Generate random data points
  --
  local data = {}
  for i = 1,npoints do
    local ang = math.random() * (2.0 * math.pi)
    local rad = math.random() * radius
    data[i] = {x = math.cos(ang) * rad, y = math.sin(ang) * rad}
  end
  return data
end

local function print_eps(data, nclusters, centers, cluster)
  local WIDTH  = 400
  local HEIGHT = 400

  -- Print an EPS file with clustered points
  --
  local colors = {}
  for k = 1,nclusters do
    colors[3*k + 0] = (3 * k % 11) / 11.0
    colors[3*k + 1] = (7 * k % 11) / 11.0
    colors[3*k + 2] = (9 * k % 11) / 11.0
  end

  local max_x, max_y, min_x, min_y = -math.maxinteger, -math.maxinteger,
    math.maxinteger, math.maxinteger

  for i = 1,#data do
    if max_x < data[i].x then max_x = data[i].x end
    if min_x > data[i].x then min_x = data[i].x end
    if max_y < data[i].y then max_y = data[i].y end
    if min_y > data[i].y then min_y = data[i].y end
  end

  local scale = WIDTH / (max_x - min_x)
  if scale > HEIGHT / (max_y - min_y) then scale = HEIGHT / (max_y - min_y) end

  local cx = (max_x + min_x) / 2.0
  local cy = (max_y + min_y) / 2.0

  print(string.format("%%!PS-Adobe-3.0\n%%%%BoundingBox: -5 -5 %d %d",
    WIDTH + 10, HEIGHT + 10))
  print(string.format("/l {rlineto} def /m {rmoveto} def\n/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def\n/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath gsave 1 setgray fill grestore gsave 3 setlinewidth 1 setgray stroke grestore 0 setgray stroke }def"
))
  -- print(string.format("%g %g %g setrgbcolor\n", 1, 2, 3))
  for k = 1,nclusters do
    print(string.format("%g %g %g setrgbcolor",
      colors[3*k], colors[3*k + 1], colors[3*k + 2]))

    for i = 1,#data do
      if cluster[i] == k then
        print(string.format("%.3f %.3f c",
          (data[i].x - cx) * scale + WIDTH  / 2.0,
          (data[i].y - cy) * scale + HEIGHT / 2.0))
      end
    end

    print(string.format("0 setgray %g %g s",
      (centers[k].x - cx) * scale + WIDTH  / 2.0,
      (centers[k].y - cy) * scale + HEIGHT / 2.0))
  end
  print(string.format("\n%%%%EOF"))
end

local function kmeans(data, nclusters, init)
  -- K-means Clustering
  --
  assert(nclusters > 0)
  assert(#data > nclusters)
  assert(init == "kmeans++" or init == "random")

  local diss = function(p, q)
    -- Computes the dissimilarity between points 'p' and 'q'
    --
    return math.pow(p.x - q.x, 2) + math.pow(p.y - q.y, 2)
  end

  -- Initialization
  --
  local centers = {} -- clusters centroids
  if init == "kmeans++" then
    local K = 1

    -- take one center c1, chosen uniformly at random from 'data'
    local i = math.random(1, #data)
    centers[K] = {x = data[i].x, y = data[i].y}
    local D = {}

    -- repeat until we have taken 'nclusters' centers
    while K < nclusters do
      -- take a new center ck, choosing a point 'i' of 'data' with probability
      -- D(i)^2 / sum_{i=1}^n D(i)^2

      local sum_D = 0.0
      for i = 1,#data do
        local min_d = D[i]
        local d = diss(data[i], centers[K])
        if min_d == nil or d < min_d then
            min_d = d
        end
        D[i] = min_d
        sum_D = sum_D + min_d
      end

      sum_D = math.random() * sum_D
      for i = 1,#data do
        sum_D = sum_D - D[i]

        if sum_D <= 0 then
          K = K + 1
          centers[K] = {x = data[i].x, y = data[i].y}
          break
        end
      end
    end
  elseif init == "random" then
    for k = 1,nclusters do
      local i = math.random(1, #data)
      centers[k] = {x = data[i].x, y = data[i].y}
    end
  end

  -- Lloyd K-means Clustering
  --
  local cluster = {} -- k-partition
  for i = 1,#data do cluster[i] = 0 end

  local J = function()
    -- Computes the loss value
    --
    local loss = 0.0
    for i = 1,#data do
      loss = loss + diss(data[i], centers[cluster[i]])
    end
    return loss
  end

  local updated = false
  repeat
    -- update k-partition
    --
    local card = {}
    for k = 1,nclusters do
      card[k] = 0.0
    end

    updated = false
    for i = 1,#data do
      local min_d, min_k = nil, nil

      for k = 1,nclusters do
        local d = diss(data[i], centers[k])

        if min_d == nil or d < min_d then
          min_d, min_k = d, k
        end
      end

      if min_k ~= cluster[i] then updated = true end

      cluster[i]  = min_k
      card[min_k] = card[min_k] + 1.0
    end
    -- print("update k-partition: ", J())

    -- update centers
    --
    for k = 1,nclusters do
      centers[k].x = 0.0
      centers[k].y = 0.0
    end

    for i = 1,#data do
      local k = cluster[i]

      centers[k].x = centers[k].x + (data[i].x / card[k])
      centers[k].y = centers[k].y + (data[i].y / card[k])
    end
    -- print("    update centers: ", J())
  until updated == false

  return centers, cluster, J()
end

 ------------------------------------------------------------------------------
 ---- MAIN --------------------------------------------------------------------

local N_POINTS   = 100000  -- number of points
local N_CLUSTERS = 11      -- number of clusters

local data = load_data(N_POINTS, N_CLUSTERS)
centers, cluster, loss = kmeans(data, N_CLUSTERS, "kmeans++")
-- print("Loss: ", loss)
-- for k = 1,N_CLUSTERS do
--   print("center.x: ", centers[k].x, " center.y: ", centers[k].y)
-- end
print_eps(data, N_CLUSTERS, centers, cluster)
