# Adding clusterization (http://apidock.com/rails/Enumerable/group_by)
module Enumerable
  # clumps adjacent elements together
  # >> [2,2,2,3,3,4,2,2,1].cluster
  # => [[2, 2, 2], [3, 3], [4], [2, 2], [1]]
  def cluster
    cluster = []
    each do |element|
      if cluster.last && cluster.last.last == element
        cluster.last << element
      else
        cluster << [element]
      end
    end
    cluster
  end
end
