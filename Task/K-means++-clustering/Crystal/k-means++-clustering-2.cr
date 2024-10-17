# -----------------------------------------------------------------------------
# Function to exercise the code, that generates a list of random points
# -----------------------------------------------------------------------------

# Generates a cluster of random points in a unitary circle
#
def uniform_cluster(num_points,radius = 1.0,center = [0.0,0.0],rng=Random::DEFAULT)
  return Array.new(num_points) do |_|
    r = radius*Math.sqrt(rng.rand(0.0 .. 1.0))
    angle = rng.rand(0.0 .. 2*Math::PI)
    [center[0] + r*Math.cos(angle), center[1] + r*Math.sin(angle)]
  end
end

# Generates an n-dimentional cluster with gaaussian distribution
def gaussian_cluster(num_points,stdev=1.0,center=[0.0,0.0],rng=Random::DEFAULT)
  dimentions = center.size
  return Array.new(num_points) do
    Array.new(dimentions) do |d|
      sum = 0.0
      12.times do sum += rng.rand(0.0 .. 1.0) end
      sum -= 6.0
      center[d] + (sum * stdev)
    end
  end
end

# -----------------------------------------------------------------------------
# Visualization of the results
# -----------------------------------------------------------------------------

# This functions creates an svg file with the points, the cluster centers and
# the classification of each point.
#
def plot(cluster_means,points,points_cluster,fname="kmeans_output.svg")
  # Mapping the points to the interval (0 .. 1)
  xmin,xmax = points.minmax_by do |p| p[0] end.map(&.[0])
  ymin,ymax = points.minmax_by do |p| p[1] end.map(&.[1])
  xspan = (xmax-xmin) + 1e-12
  yspan = (ymax-ymin) + 1e-12
  points = points.map  do |p|
    x = (p[0] - xmin) / xspan
    y = (ymin - p[1]) / yspan
    [x,y]
  end
  cluster_means = cluster_means.map  do |p|
    x = (p[0] - xmin) / xspan
    y = (ymin - p[1]) / yspan
    [x,y]
  end

  # Generate the file
  File.open(fname,"w+") do |io|
    io.puts(%(<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="-0.05 -1.05 1.1 1.1">))
    (0 ... points.size).each do |p_index|
      p = points[p_index]
      c = points_cluster[p_index] * (330.0 / cluster_means.size)
      io.puts(%(<circle cx="#{p[0]}" cy="#{p[1]}" r="0.005" fill="hsl(#{c} 60% 50%)" stroke="none"></circle>))
    end
    (0 ... cluster_means.size).each do |c_index|
      p = cluster_means[c_index]
      c = c_index * (330.0 / cluster_means.size)
      io.puts(%(<circle cx="#{p[0]}" cy="#{p[1]}" r="0.02" fill="hsl(50 100% 60%)"
        stroke-width="0.004" stroke="hsl(52 100% 0%)"></circle>))
    end
    io.puts(%(</svg>))
  end
end
