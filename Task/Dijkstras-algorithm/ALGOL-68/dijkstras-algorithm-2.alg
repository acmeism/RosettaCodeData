#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

CO REQUIRED BY "prelude_dijkstras_algorithm.a68" CO
  MODE ROUTELEN = INT,
  ROUTELEN route len infinity = max int,
  PROC route len add = (VERTEX v, ROUTE r)ROUTELEN:
    route len OF v + route len OF r; # or MAX(v,r) #
  MODE VERTEXPAYLOAD = STRING,
  PROC dijkstra fix value error = (STRING msg)BOOL:
    (put(stand error, (msg, new line)); FALSE);
#PROVIDES:#
# VERTEX*=~* #
# ROUTE*=~* #
# vertex route*=~* #
PR READ "prelude_dijkstras_algorithm.a68" PR;

FORMAT vertex data fmt = $g$;

main:(
  INT upb graph = 6, upb route list = 9;

  HEAP[upb graph]VALVERTEX graph;

# name the key vertices #
  FOR this TO UPB graph DO graph[this] INIT STRING("abcdef"[this]) OD;

# declare some variables of the same name #
  VERTEX a := graph[1], b := graph[2], c := graph[3],
         d := graph[4], e := graph[5], f := graph[6];

# define the graph #
  HEAP FLEX[upb route list]VALROUTE route list := (
      (a, b, 7),  (a, c, 9),  (a, f, 14),
      (b, c, 10), (b, d, 15),
      (c, d, 11), (c, f, 2),
      (d, e, 6),
      (e, f, 9)
  );

# FOR VERTEXROUTE vertex route IN # vertex route gen dijkstra(a, e, route list#) DO #,
##   (VERTEXROUTE vertex route)VOID: (
        CASE vertex route IN
          (VERTEX vertex): printf((vertex data fmt, vertex data OF vertex)),
          (ROUTE route): printf(($" --"g(0)"-> "$, route len OF route))
        ESAC
# OD #));
  print(new line)

# TODO: generate random 100000 VERTEX graph test case and test performance - important #

)
