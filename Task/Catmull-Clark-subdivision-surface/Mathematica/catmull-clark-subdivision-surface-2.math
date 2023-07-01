CatMullClark[{Points_,faces_}]:=Block[{avgFacePoints,avgEdgePoints,updatedPoints,newEdgePoints,newPoints,edges,newFaces,weights,pointUpdate,edgeUpdate,newIndex},
edges = DeleteDuplicates[Flatten[Partition[#,2,1,-1]&/@faces,1],Sort[#1]==Sort[#2]&];
avgFacePoints=Mean[Points[[#]]] &/@ faces;
avgEdgePoints=Mean[Points[[#]]] &/@ edges;

weights[vertex_]:= Count[faces,vertex,2]//{(#-3),1,2}/#&;
pointUpdate[vertex_]:=
	If[Length[faces~containing~vertex]!=Length[edges~containing~vertex],
		Mean[avgEdgePoints[[Select[edges~containing~vertex,holeQ[edges[[#]],faces]&]]]],
		Total[weights[vertex]{ Points[[vertex]], Mean[avgFacePoints[[faces~containing~vertex]]], Mean[avgEdgePoints[[edges~containing~vertex]]]}]
	];

edgeUpdate[edge_]:=
	If[Length[faces~containing~edge]==1,
		Mean[Points[[edge]]],
		Mean[Points[[Flatten[{edge, faces[[faces~containing~edge]]}]]]]
	];

updatedPoints = pointUpdate/@Range[1,Length[Points]];
newEdgePoints = edgeUpdate/@edges;
newPoints = Join[updatedPoints,avgFacePoints,newEdgePoints];

newIndex[edge_/;Length[edge]==2]  := Length[Points]+Length[faces]+Position[Sort/@edges,Sort@edge][[1,1]]
newIndex[face_] := Length[Points]+Position[faces,face][[1,1]]

newFaces  = Flatten[Map[newIndex[#,{Points,edges,faces}]&,ReplaceFace/@faces,{-2}],1];
{newPoints,newFaces}
]
