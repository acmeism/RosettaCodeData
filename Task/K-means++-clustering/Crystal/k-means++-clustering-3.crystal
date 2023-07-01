rngseed = 19

# Basic usage
points = uniform_cluster(num_points: 30000,rng: Random.new(rngseed))
cluster_center,point_cluster = kmeans(6, points, rng: Random.new(rngseed))
plot(cluster_center,points,point_cluster,fname: "clustering-using-k-means-pp.svg")

# Using another distance
points = uniform_cluster(num_points: 30000,rng: Random.new(rngseed))
cluster_center,point_cluster = kmeans(6, points, rng: Random.new(rngseed),
  distance: ->manhattan_distance(Array(Float64),Array(Float64)))
plot(cluster_center,points,point_cluster,fname: "clustering-using-k-means-pp-and-manhattan.svg")

# difficult case
points = [] of Array(Float64)
rng = Random.new(rngseed)
points += gaussian_cluster(num_points: 10000,stdev: 0.5,center: [0.0,0.0],rng: rng)
points += gaussian_cluster(num_points: 10000,stdev: 0.5,center: [2.0,3.0],rng: rng)
points += gaussian_cluster(num_points: 10000,stdev: 0.5,center: [2.5,-1.0],rng: rng)
points += gaussian_cluster(num_points: 10000,stdev: 0.5,center: [6.0,0.0],rng: rng)
cluster_center,point_cluster = kmeans(4, points, rng: Random.new(rngseed))
plot(cluster_center,points,point_cluster,fname: "gaussian-clustering.svg")

# 5d-data
points = [] of Array(Float64)
rng = Random.new(rngseed)
points += gaussian_cluster(num_points: 5000,stdev: 0.5, center: [2.0,0.0,0.0,0.0,0.0],rng: rng)
points += gaussian_cluster(num_points: 5000,stdev: 0.5, center: [0.0,2.0,0.0,0.0,0.0],rng: rng)
points += gaussian_cluster(num_points: 5000,stdev: 0.5, center: [0.0,0.0,2.0,0.0,0.0],rng: rng)
points += gaussian_cluster(num_points: 5000,stdev: 0.5, center: [0.0,0.0,0.0,2.0,0.0],rng: rng)
points += gaussian_cluster(num_points: 5000,stdev: 0.5, center: [0.0,0.0,0.0,0.0,2.0],rng: rng)
cluster_center,point_cluster = kmeans(5, points, convergence_threshold:0.99999)
puts(cluster_center.map(&.map(&.round(2))).join("\n"))
