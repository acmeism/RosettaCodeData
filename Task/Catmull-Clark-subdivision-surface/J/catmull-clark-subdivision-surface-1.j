avg=: +/ % #

havePoints=: e."1/~ i.@#

catmullclark=:3 :0
  'mesh points'=. y
  face_point=. avg"2 mesh{points
  point_face=. |: mesh havePoints points
  avg_face_points=. point_face avg@#"1 2 face_point
  edges=. ~.,/ meshEdges=. mesh /:~@,"+1|."1 mesh
  edge_face=. *./"2 edges e."0 1/ mesh
  edge_center=. avg"2 edges{points
  edge_point=. (0.5*edge_center) + 0.25 * edge_face +/ .* face_point
  point_edge=. |: edges havePoints points
  avg_mid_edges=.  point_edge avg@#"1 2 edge_center
  n=. +/"1 point_edge
  'm3 m2 m1'=. (2,1,:n-3)%"1 n
  new_coords=. (m1 * points) + (m2 * avg_face_points) + (m3 * avg_mid_edges)
  pts=. face_point,edge_point,new_coords
  c0=. (#edge_point)+ e0=. #face_point
  msh=. (,c0+mesh),.(,e0+edges i. meshEdges),.((#i.)~/$mesh),.,e0+_1|."1 edges i. meshEdges
  msh;pts
)
