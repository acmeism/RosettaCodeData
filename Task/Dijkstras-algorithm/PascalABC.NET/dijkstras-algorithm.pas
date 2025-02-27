type
  Edge = auto class
    start, &end: char;
    cost: real;
  end;

  Graph = auto class
    edges: array of Edge;
    vertices: HashSet<char>;

    constructor(params edges: array of (char, char, real));
    begin
      Self.edges := edges.Select(e -> new Edge(e[0], e[1], e[2])).ToArray;
      Self.vertices := new HashSet<char>(
        Self.edges.Select(e -> e.start) + Self.edges.Select(e -> e.end)
      );
    end;

    function Dijkstra(source, dest: char): sequence of char;
    begin
      assert(vertices.Contains(source));

      var inf := real.MaxValue;
      var dist := Dict(vertices.Select(v -> (v, inf)));
      var previous := Dict(vertices.Select(v -> (v, ' ')));
      dist[source] := 0;

      var q := vertices.ToHashSet;
      var neighbours := Dict(vertices.Select(v -> (v, new HashSet<(char, real)>)));

      foreach var edge in edges do
      begin
        neighbours[edge.start].Add((edge.end, edge.cost));
        neighbours[edge.end].Add((edge.start, edge.cost));
      end;

      while q.Count > 0 do
      begin
        var u := q.MinBy(v -> dist[v]);
        q.Remove(u);

        if (dist[u] = inf) or (u = dest) then
          break;

        foreach var (v, cost) in neighbours[u] do
        begin
          var alt := dist[u] + cost;
          if alt < dist[v] then
          begin
            dist[v] := alt;
            previous[v] := u;
          end;
        end;
      end;

      var s := new List<char>;
      var u := dest;

      while previous[u] <> ' ' do
      begin
        s.Insert(0, u);
        u := previous[u];
      end;

      s.Insert(0, u);
      Result := s;
    end;
  end;

begin
  var gr := new Graph(
    ('a', 'b', 7.0), ('a', 'c', 9.0), ('a', 'f', 14.0),
    ('b', 'c', 10.0), ('b', 'd', 15.0), ('c', 'd', 11.0),
    ('c', 'f', 2.0), ('d', 'e', 6.0), ('e', 'f', 9.0)
  );

  gr.Dijkstra('a', 'e').Println;
end.
