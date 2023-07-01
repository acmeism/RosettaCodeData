Dijkstra(data, start){
	nodes := [], dist := [], Distance := [], dist := [], prev := [], Q := [], min := "x"
	for each, line in StrSplit(data, "`n" , "`r")
		field := StrSplit(line,"`t"), nodes[field.1] := 1, nodes[field.2] := 1
		, Distance[field.1,field.2] := field.3, Distance[field.2,field.1] := field.3
	dist[start] := 0, prev[start] := ""

	for node in nodes {
		if (node <> start)
			dist[node] := "x"
			, prev[node] := ""
		Q[node] := 1
	}
	
	while % ObjCount(Q) {
		u := MinDist(Q, dist).2
		for node, val in Q
			if (node = u) {
				q.Remove(node)
				break
			}
			
		for v, length in Distance[u] {
			alt := dist[u] + length
			if (alt < dist[v])
				dist[v] := alt	
				, prev[v] := u
		}
	}
	return [dist, prev]
}
;-----------------------------------------------
MinDist(Q, dist){
	for node , val in Q
		if A_Index=1
			min := dist[node], minNode := node
		else
			min := min < dist[node] ? min : dist[node]	, minNode := min < dist[node] ? minNode : node		
	return [min,minNode]
}
ObjCount(Obj){
	for key, val in Obj
		count := A_Index
	return count
}
