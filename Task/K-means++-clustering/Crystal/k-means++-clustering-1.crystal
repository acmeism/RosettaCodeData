# kmeans++ clustering in crystal lang
#
# Task :: function that takes two arguments
#   k      : uint      - the number of clusters
#   points : [[float]] - the dataset to classify
#
#   and returns a list of clusters

# The algorithm of kmeans with a specific initialization
#
# k                     : int                      - number of clusters
# points                : [[float]]                - the dataset of k-dimentional points
# distance              : ([float],[float])->float - the distance between two points
# convergence_threshold : float                    - ratio of correctly classified points
# rng                   : (msg)->float             - random number generator
#
# {[[float]],[int]} - returns a tuple of the center of the cluster and an array
# with the cluster-id for each point.
#
def kmeans(k, points,
  distance = ->euclidean_distance(Array(Float64),Array(Float64)),
  convergence_threshold=0.99,
  rng = Random::DEFAULT)

  # ---------------------------------------------------------------------------
  # the k++ method for choosing the initial values ('seeds') for the k-means
  # clustering.
  # ---------------------------------------------------------------------------

  # arrays of the clusters centers and the number of elements in each cluster
  c_means = points.sample(k,rng).clone
  c_cnt   = Array.new(k,0)

  # arrays for each point distance to nearest cluster and the nearest cluster id
  p_dist = Array.new(points.size) do 1/0.0 end
  p_cluster = Array.new(points.size) do rng.rand(0 ... k) end

  # choose one center uniformly at random among data points
  c_means = [points.sample.clone]

  # to select the k-1 remaining centers
  (1 ... k).each do |_|
    # For each data point compute the distance (d(x)) and the nearest cluster center.
    (0 ... points.size).each do |p_index|
      (0 ... c_means.size).each do |c_index|
        d = distance.call(points[p_index],c_means[c_index])
        if d < p_dist[p_index]
          p_dist[p_index] = d
          p_cluster[p_index] = c_index
        end
      end
    end

    # choose one new data point at random as a new center with a weighted
    # probability distribution where a point is chosen with probability
    # proportional to it's squared distance. (d(x)^2)
    sum = 0.0
    (0 ... p_dist.size).each do |p_index|
      p_dist[p_index] = p_dist[p_index]**2
      sum += p_dist[p_index]
    end
    sum *= rng.rand(0.0 .. 1.0)
    (0 ... points.size).each do |p_index|
      sum -= p_dist[p_index]
      next if sum > 0
      c_means.push(points[p_index].clone)
      break
    end
  end

  # ---------------------------------------------------------------------------
  # kmeans clustering
  # ---------------------------------------------------------------------------

  # with the previous cluster centers, the kmeans naive algorithm is performed
  # until the convergence_threshold is achieved
  changes_cnt = points.size
  while (changes_cnt.to_f/(1.0-convergence_threshold)) >= points.size

    changes_cnt = 0

    # assign each point to the nearest cluster
    (0 ... points.size).each do |p_index|
      nearest_c_index = (0 ... k).min_by do |c_index|
        distance.call(c_means[c_index],points[p_index])
      end
      changes_cnt += (p_cluster[p_index] != nearest_c_index) ? 1 : 0
      p_cluster[p_index] = nearest_c_index
    end

    # use the points of each cluster to calculate its center using the mean

    # Reset means
    p_dim = points[0].size
    (0 ... k).each do |c_index|
      (0 ... p_dim).each do |x_index|
        c_means[c_index][x_index] = 0.0
        c_cnt[c_index] = 0
      end
    end

    # calculate the mean of the points of each cluster
    (0 ... points.size).each do |p_index|
      c_index = p_cluster[p_index]
      c_cnt[c_index] += 1
      (0 ... p_dim).each do |x_index|
        c_means[c_index][x_index] += points[p_index][x_index]
      end
    end
    (0 ... k).each do |c_index|
      (0 ... p_dim).each do |x_index|
        c_means[c_index][x_index] /= c_cnt[c_index].to_f
      end
    end
  end

  # return the center of each cluster and the membership of each point
  return c_means,p_cluster
end

# the euclidean distance is used in the kmeans++-algorithm
def euclidean_distance(pa,pb)
  return (0 ... pa.size).each.reduce(0.0) do |s,i| s + (pa[i] - pb[i])**2 end
end

# alternative distance
def manhattan_distance(pa,pb)
  return (0 ... pa.size).each.reduce(0.0) do |s,i| s + (pa[i] - pb[i]).abs end
end
