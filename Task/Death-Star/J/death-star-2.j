load'graphics/viewmat'

resolution=: 8
spheres=: 3 1 #"1 ] 0 1,_1 1,:0.3 0.6  NB. spheres x y z r


coordinates=: (% <:)~ (,"1 0~"0 3 ,"0"1 0~)@:i:
length=: +/ &.: *:
centers=: _ 3&{.
radii=: _ _1&{.

NB. resolution SlicePittedSphere spheres  generates a binary array, 1 in the geometric object
SlicePittedSphere=: (0 { {. > [: +./ }.)@:(radii@[ >:"0 3 ((length@:-"1"_ 1 centers)~ coordinates))~

spanTo=: conjunction def '(m<:y)*.y<:n'     NB. algebraic similarity, m <= y <= n

tessellate=: ] ];._3"3~ 3 # [               NB. All cubical edge length x subarrays of array y

NB. Define "faces" as those points with 9 to 18 inclusive "solid" neighbors.
detectFace=: (9 spanTo 18) @: (+/@:,"3) @: (3&tessellate)

NB. arrange faces in ANSYS brick face order
ThickFaces=: ((|:"3 , (, |:"2))(,: |."1)3 3 3$2j1#1) /: 'SENWDU' i. 'DUEWSN'
ThinFaces=:  ((|:"3 , (, |:"2))(,: |."1)3 3 3$1j2#1) /: 'SENWDU' i. 'DUEWSN'

FACES=:ThickFaces  NB. 6 below comes from #Faces

NORMALS=: 2 tessellate FACES

matchNormals=: [: +/@,"6 NORMALS ="6"6 _ (2 tessellate 3 tessellate ])

bestFit=: (i.>./)"1&.|:

topFace=: detectFace i:"1 1:

choose=: 4 : 'x}y'

viewmat resolution (topFace choose (,&(#FACES))@:bestFit@matchNormals)@SlicePittedSphere spheres


   <"_1 ThickFaces         NB. display the 6 cubes with reference faces
┌─────┬─────┬─────┬─────┬─────┬─────┐
│1 1 1│1 1 0│0 0 0│0 1 1│1 1 1│0 0 0│
│1 1 1│1 1 0│1 1 1│0 1 1│1 1 1│0 0 0│
│0 0 0│1 1 0│1 1 1│0 1 1│1 1 1│0 0 0│
│     │     │     │     │     │     │
│1 1 1│1 1 0│0 0 0│0 1 1│1 1 1│1 1 1│
│1 1 1│1 1 0│1 1 1│0 1 1│1 1 1│1 1 1│
│0 0 0│1 1 0│1 1 1│0 1 1│1 1 1│1 1 1│
│     │     │     │     │     │     │
│1 1 1│1 1 0│0 0 0│0 1 1│0 0 0│1 1 1│
│1 1 1│1 1 0│1 1 1│0 1 1│0 0 0│1 1 1│
│0 0 0│1 1 0│1 1 1│0 1 1│0 0 0│1 1 1│
└─────┴─────┴─────┴─────┴─────┴─────┘
