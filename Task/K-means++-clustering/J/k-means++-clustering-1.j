   NB.  Selection of initial centroids, per K-means++
   initialCentroids     =:  (] , randomCentroid)^:(<:@:]`(,:@:seedCentroid@:[))~
     seedCentroid       =:  {~ ?@#
     randomCentroid     =:  [ {~ [: wghtProb [: <./ distance/~
       distance         =:  +/&.:*:@:-"1  NB.  Extra credit #3 (N-dimensional is the same as 2-dimensional in J)
       wghtProb         =:  1&$: : ((%{:)@:(+/\)@:] I. [ ?@$ 0:)"0 1 NB.  Due to Roger Hui http://j.mp/lj5Pnt

   NB.  Having selected the initial centroids, the standard K-means algo follows
   centroids            =:  ([ mean/.~ closestCentroid)^:(]`_:`initialCentroids)
     closestCentroid    =:  [: (i.<./)"1 distance/
     mean               =:  +/ % #
