USING: kernel prettyprint sequences arrays math math.vectors ;
IN: raycasting

: between ( a b x -- ? ) [ last ] tri@ [ < ] curry bi@ xor ;

: lincomb ( a b x -- w )
  3dup [ last ] tri@
  [ - ] curry bi@
  [ drop ] 2dip
  neg 2dup + [ / ] curry bi@
  [ [ v*n ] curry ] bi@ bi*  v+ ;
: leftof ( a b x -- ? ) dup [ lincomb ] dip [ first ] bi@ > ;

: ray ( a b x -- ? ) [ between ] [ leftof ] 3bi and ;

: raycast ( poly x -- ? )
  [ dup first suffix [ rest-slice ] [ but-last-slice ] bi ] dip
  [ ray ] curry 2map
  f [ xor ] reduce ;
