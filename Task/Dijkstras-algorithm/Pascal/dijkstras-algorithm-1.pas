program dijkstra(output);

type
  { We dynamically build the list of vertices from the edge list,
    just to avoid repeating ourselves in the graph input. Vertices are linked
    together via their `next` pointers to form a list of all vertices (sorted by
    name), while the `previous` pointer indicates the previous vertex along the
    shortest path to this one. }
  vertex = record
    name: char;
    visited: boolean;
    distance: integer;
    previous: ^vertex;
    next: ^vertex;
  end;

  vptr = ^vertex;

  { The graph is specified as an array of these }
  edge_desc = record
    source: char;
    dest: char;
    weight: integer;
  end;

const
  { the input graph }
  edges:    array of edge_desc = (
    (source:'a'; dest:'b'; weight:7),
    (source:'a'; dest:'c'; weight:9),
    (source:'a'; dest:'f'; weight:14),
    (source:'b'; dest:'c'; weight:10),
    (source:'b'; dest:'d'; weight:15),
    (source:'c'; dest:'d'; weight:11),
    (source:'c'; dest:'f'; weight:2),
    (source:'d'; dest:'e'; weight:6),
    (source:'e'; dest:'f'; weight:9)
  );

  { find the shortest path to all nodes starting from this one }
  origin: char = 'a';

var
  head_vertex: vptr = nil;
  curr, next, closest: vptr;
  vtx: vptr;
  dist: integer;
  edge: edge_desc;
  done: boolean = false;

{ allocate a new vertex node with the given name and `next` pointer }
function new_vertex(key: char; next: vptr): vptr;

  var
    vtx: vptr;
  begin
    new(vtx);
    vtx^.name := key;
    vtx^.visited := false;
    vtx^.distance := maxint;
    vtx^.previous := nil;
    vtx^.next := next;
    new_vertex := vtx;
  end;


{ look up a vertex by name; create it if needed }
function find_or_make_vertex(key: char): vptr; var
    vtx, prev, found: vptr;
    done: boolean;

  begin

    found := nil;
    if head_vertex = nil then
      head_vertex := new_vertex(key, nil)
    else if head_vertex^.name > key then
      head_vertex := new_vertex(key, head_vertex);

    if head_vertex^.name = key then
      found := head_vertex
    else begin
      prev := head_vertex;
      vtx := head_vertex^.next;
      done := false;
      while not done do
        if vtx = nil then
          done := true
        else if vtx^.name >= key then
          done := true
        else begin
          prev := vtx;
          vtx := vtx^.next
        end;
      if vtx <> nil then
        if vtx^.name = key then
          found := vtx;
      if found = nil then begin
        prev^.next := new_vertex(key, vtx);
        found := prev^.next;
      end
    end;
    find_or_make_vertex := found
  end;

{ display the path to a vertex indicated by its `previous` pointer chain }
procedure write_path(vtx: vptr);
  begin
    if vtx <> nil then begin
      if vtx^.previous <> nil then begin
        write_path(vtx^.previous);
        write('→');
      end;
      write(vtx^.name);
    end;
  end;

begin
  curr := find_or_make_vertex(origin);
  curr^.distance := 0;
  curr^.previous := nil;
  while not done do begin
    for edge in edges do begin
      if edge.source = curr^.name then begin
        next := find_or_make_vertex(edge.dest);
        dist := curr^.distance + edge.weight;
        if dist < next^.distance then begin
           next^.distance := dist;
           next^.previous := curr;
        end
      end
    end;
    curr^.visited := true;
    closest := nil;
    vtx := head_vertex;
    while vtx <> nil do begin
      if not vtx^.visited then
        if closest = nil then
          closest := vtx
        else if vtx^.distance < closest^.distance then
          closest := vtx;
      vtx := vtx^.next;
    end;
    if closest = nil then
      done := true
    else if closest^.distance = maxint then
      done := true;
    curr := closest;
  end;
  writeln('Shortest path to each vertex from ', origin, ':');
  vtx := head_vertex;
  while vtx <> nil do begin
    write(vtx^.name, ':', vtx^.distance);
    if vtx^.distance > 0 then begin
      write(' (');
      write_path(vtx);
      write(')');
    end;
    writeln();
    vtx := vtx^.next;
  end
end.
