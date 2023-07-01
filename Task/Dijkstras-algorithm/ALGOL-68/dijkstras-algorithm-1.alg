# -*- coding: utf-8 -*- #

COMMENT REQUIRED BY "prelude_dijkstras_algorithm.a68" CO
  MODE ROUTELEN = ~;
  ROUTELEN route len infinity = max ~;
  PROC route len add = (VERTEX v, ROUTE r)ROUTELEN:
    route len OF v + route len OF r; # or MAX(v,r) #
  MODE VERTEXPAYLOAD = ~;
  PROC dijkstra fix value error = (STRING msg)BOOL:
    (put(stand error, (msg, new line)); FALSE);
#PROVIDES:#
# VERTEX*=~* #
# ROUTE*=~* #
# vertex route*=~* #
END COMMENT

MODE VALVERTEX = STRUCT(
    ROUTELEN route len,
    FLEX[0]ROUTE route,
    ROUTE shortest route,
    VERTEXPAYLOAD vertex data
);

MODE VERTEX = REF VALVERTEX;
MODE VERTEXYIELD = PROC(VERTEX)VOID; # used to "generate" VERTEX path #
PRIO INIT = 1; # The same PRIOrity as +:= etc #
OP INIT = (VERTEX self, VERTEXPAYLOAD vertex data)VERTEX:
  self := (route len infinity, (), NIL, vertex data);

# It may be faster to preallocate "queue", rather then grow a FLEX #
OP +:= = (REF FLEX[]VERTEX in list, VERTEX rhs)REF FLEX[]VERTEX: (
  [UPB in list+1]VERTEX out list;
  out list[:UPB in list] := in list;
  out list[UPB out list] := rhs;
  in list := out list # EXIT #
);

MODE VALROUTE = STRUCT(VERTEX from, to, ROUTELEN route len#, ROUTEPAYLOAD#);
MODE ROUTE = REF VALROUTE;

OP +:= = (REF FLEX[]ROUTE in list, ROUTE rhs)REF FLEX[]ROUTE: (
  [UPB in list+1]ROUTE out list;
  out list[:UPB in list] := in list;
  out list[UPB out list] := rhs;
  in list := out list # EXIT #
);

MODE VERTEXROUTE = UNION(VERTEX, ROUTE);
MODE VERTEXROUTEYIELD = PROC(VERTEXROUTE)VOID;

################################################################
# Finally: now the strong typing is in place, the task code... #
################################################################
PROC vertex route gen dijkstra = (
    VERTEX source, target,
    REF[]VALROUTE route list,
    VERTEXROUTEYIELD yield
  )VOID:(

# initialise the route len for BOTH directions on each route #
  FOR this TO UPB route list DO
    ROUTE route = route list[this];
    route OF from OF route +:= route;
# assume route lens is the same in both directions, this i.e. NO A-B gradient NOR 1-way streets #
    route OF to OF route +:= (HEAP VALROUTE := (to OF route, from OF route, route len OF route))
  OD;

  COMMENT
  Algorithium Performance "about" O(n**2)...
  Optimisations:
       a) bound index in [lwb queue:UPB queue] for search
       b) delay adding vertices until they are actually encountered
  It may be faster to preallocate "queue" vertex list, rather then grow a FLEX
  END COMMENT

  PROC vertex gen nearest = (REF FLEX[]VERTEX queue, VERTEXYIELD yield)VOID: (
    INT vertices done := 0, lwb queue := 1;
    ROUTELEN shortest route len done := -route len infinity;
    WHILE vertices done <= UPB queue ANDF shortest route len done NE route len infinity DO
      ROUTELEN shortest route len := route len infinity;
# skip done elements: #
      FOR this FROM lwb queue TO UPB queue DO
        VERTEX this vertex := queue[this];
        IF NOT(shortest route len done < route len OF this vertex) THEN
          lwb queue := this; # remember for next time #
          break
        FI
      OD;
    break:
# find vertex with shortest path attached #
      FOR this FROM lwb queue TO UPB queue DO VERTEX this vertex := queue[this];
        IF shortest route len done < route len OF this vertex ANDF
           route len OF this vertex < shortest route len THEN
           shortest route len := route len OF this vertex FI
      OD;
# update the other vertices with shortest path found #
      FOR this FROM lwb queue TO UPB queue DO VERTEX this vertex := queue[this];
        IF route len OF this vertex = shortest route len THEN
           vertices done +:= 1; yield(this vertex) FI
      OD;
      shortest route len done := shortest route len
    OD
  );

  route len OF target := 0;
  FLEX[0]VERTEX queue := target;

# FOR VERTEX this vertex IN # vertex gen nearest(queue#) DO (#,
##   (VERTEX this vertex)VOID: (
    FOR this TO UPB route OF this vertex DO ROUTE this route = (route OF this vertex)[this];

    # If this vertex has not been encountered before, then add to queue #
      IF route len OF to OF this route = route len infinity THEN queue +:= to OF this route FI;

      ROUTELEN route len = route len add(this vertex, this route);
      IF route len < route len OF to OF this route THEN
        route len OF to OF this route := route len;
        shortest route OF to OF this route := this route
      FI
    OD;

    IF this vertex IS source THEN done FI
# OD#));
  IF NOT dijkstra fix value error("no path found") THEN stop FI;

############################
# Now: generate the result #
############################
  done: (
    VERTEX this vertex := source;
    WHILE
      yield(this vertex);
      ROUTE this route = shortest route OF this vertex;
  # WHILE # this route ISNT ROUTE(NIL) DO
      yield(this route);
      this vertex := from OF this route
    OD
  )
);

SKIP
