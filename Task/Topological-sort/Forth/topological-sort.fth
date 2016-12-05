variable nodes 0 nodes ! \ linked list of nodes

: node. ( body -- )
    body> >name name>string type ;

: nodeps ( body -- )
    \ the word referenced by body has no (more) dependencies to resolve
    ['] drop over ! node. space ;

: processing ( body1 ... bodyn body -- body1 ... bodyn )
    \ the word referenced by body is in the middle of resolving dependencies
    2dup <> if \ unless it is a self-reference (see task description)
	['] drop over !
	." (cycle: " dup node. >r 1 begin \ print the cycle
	    dup pick dup r@ <> while
		space node. 1+ repeat
	." ) " 2drop r>
	then drop ;

: >processing ( body -- body )
    ['] processing over ! ;

: node ( "name" -- )
    \ define node "name" and initialize it to having no dependences
    create
    ['] nodeps , \ on definition, a node has no dependencies
    nodes @ , lastxt nodes ! \ linked list of nodes
  does> ( -- )
    dup @ execute ; \ perform xt associated with node

: define-nodes ( "names" <newline> -- )
    \ define all the names that don't exist yet as nodes
    begin
	parse-name dup while
	    2dup find-name 0= if
		2dup nextname node then
	    2drop repeat
    2drop ;

: deps ( "name" "deps" <newline> -- )
    \ name is after deps.  Implementation: Define missing nodes, then
    \ define a colon definition for
    >in @ define-nodes >in !
    ' :noname ]] >processing [[ source >in @ /string evaluate ]] nodeps ; [[
    swap >body ! 0 parse 2drop ;

: all-nodes ( -- )
    \ call all nodes, and they then print their dependences and themselves
    nodes begin
	@ dup while
	    dup execute
	    >body cell+ repeat
    drop ;

deps des_system_lib std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
deps dw01           ieee dw01 dware gtech
deps dw02           ieee dw02 dware
deps dw03           std synopsys dware dw03 dw02 dw01 ieee gtech
deps dw04           dw04 ieee dw01 dware gtech
deps dw05           dw05 ieee dware
deps dw06           dw06 ieee dware
deps dw07           ieee dware
deps dware          ieee dware
deps gtech          ieee gtech
deps ramlib         std ieee
deps std_cell_lib   ieee std_cell_lib
deps synopsys
\ to test the cycle recognition (overwrites dependences for dw1 above)
deps dw01           ieee dw01 dware gtech dw04

all-nodes
