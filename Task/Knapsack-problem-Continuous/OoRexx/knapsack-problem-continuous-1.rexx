/*--------------------------------------------------------------------
* 20.09.2014 Walter Pachl translated from REXX version 2
*            utilizing ooRexx features like objects, array(s) and sort
*-------------------------------------------------------------------*/
  maxweight = 15.0
  items=.array~new
  items~append(.item~new('beef',    3.8, 36.0))
  items~append(.item~new('pork',    5.4, 43.0))
  items~append(.item~new('ham',     3.6, 90.0))
  items~append(.item~new('greaves', 2.4, 45.0))
  items~append(.item~new('flitch',  4.0, 30.0))
  items~append(.item~new('brawn',   2.5, 56.0))
  items~append(.item~new('welt',    3.7, 67.0))
  items~append(.item~new('salami',  3.0, 95.0))
  items~append(.item~new('sausage', 5.9, 98.0))

  /* show the input */
  Say '#    vpu name    weight   value'
  i=0
  Do x over items
    i+=1
    Say i format(x~vpu,2,3) left(x~name,7) format(x~weight,2,3) format(x~value,3,3)
    End

  /* sort the items by descending value per unit of weight */
  items~sortWith(.DescendingComparator~new)

  total_weight=0
  total_value =0
  Say ' '
  Say 'Item     Weight   Value'
  i=0
  Do x over items
    i+=1
    Parse Var item.i name '*' weight '*' value
    if total_weight+x~weight<maxweight then Do
      total_weight = total_weight + x~weight
      total_value  = total_value + x~value
      Say left(x~name,7) format(x~weight,3,3) format(x~value,3,3)
      End
    Else Do
      weight=maxweight-total_weight
      value=weight*x~vpu
      total_value = total_value + value
      total_weight = maxweight
      Say left(x~name,7) format(weight,3,3) format(value,3,3)
      Leave
      End
    End
  Say copies('-',23)
  Say 'total ' format(total_weight,4,3) format(total_value,3,3)
  Exit

::class item
  ::attribute vpu
  ::attribute name
  ::attribute weight
  ::attribute value

::method init
  Expose vpu
  Use Arg name, weight, value
  self~name=name
  self~weight=weight
  self~value=value
  self~vpu=value/weight

::CLASS 'DescendingComparator' MIXINCLASS Comparator
::METHOD compare
use strict arg a, b
Select
  When (a~vpu)<(b~vpu) Then res='1'
  Otherwise res='-1'
  End
Return res
