   plotRandomClusters   =:  3&$: : (dyad define)
	dataset          =.  randMatrix 2 {. y,2

	centers          =.  x centroids dataset
	clusters         =.  centers (closestCentroid~ </. ])  dataset
	centers plotClusters clusters
)

     plotRandomClusters 300         NB.  300 points, 3 clusters
   6 plotRandomClusters 30000       NB.  3e5 points, 6 clusters
  10 plotRandomClusters 17000 5     NB.  17e3 points, 10 clusters, 5 dimensions
