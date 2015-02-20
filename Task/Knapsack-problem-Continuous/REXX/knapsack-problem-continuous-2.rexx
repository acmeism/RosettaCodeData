 /*--------------------------------------------------------------------
 * 19.09.2014 Walter Pachl translated from FORTRAN
 * While this program works with all REXX interpreters,
 * see section ooRexx for a version that utilizes the ooRexx features
 *-------------------------------------------------------------------*/
  maxweight = 15.0
  input.0=0
  Call init_input 'beef',    3.8, 36.0
  Call init_input 'pork',    5.4, 43.0
  Call init_input 'ham',     3.6, 90.0
  Call init_input 'greaves', 2.4, 45.0
  Call init_input 'flitch',  4.0, 30.0
  Call init_input 'brawn',   2.5, 56.0
  Call init_input 'welt',    3.7, 67.0
  Call init_input 'salami',  3.0, 95.0
  Call init_input 'sausage', 5.9, 98.0

  /* sort the items by descending value per unit of weight */
  Do i = 1 to input.0
    Parse Var input.i name '*' weight '*' value
    vpu=value/weight;
    If i=1 Then Do
      item.0=1
      item.1=input.1
      vpu.1=vpu
      End
    Else Do
      Do ii=1 To item.0
        If vpu.ii<vpu Then
          Leave
        End
      Do jj=item.0 To ii By -1
        jj1=jj+1
        item.jj1=item.jj
        vpu.jj1=vpu.jj
        End
      item.ii=input.i
      vpu.ii=vpu
      item.0=item.0+1
      End
    End
  Say '#    vpu name    weight   value'
  Do i=1 To item.0
    Parse Var item.i name '*' weight '*' value
    Say i format(vpu.i,2,3) left(name,7) format(weight,2,3) format(value,3,3)
    End

  total_weight=0
  total_value =0
  Say ' '
  Say 'Item     Weight   Value'
  Do i=1 To item.0
    Parse Var item.i name '*' weight '*' value
    if total_weight+weight < maxweight then Do
      total_weight = total_weight + weight
      total_value  = total_value + value
      Say left(name,7) format(weight,3,3) format(value,3,3)
      End
    Else Do
      weight=maxweight-total_weight
      value=weight*vpu.i
      total_value = total_value + value
      total_weight = maxweight
      Say left(name,7) format(weight,3,3) format(value,3,3)
      Leave
      End
    End
  Say copies('-',23)
  Say 'total ' format(total_weight,4,3) format(total_value,3,3)
  Exit

init_input: Procedure Expose input.
  Parse Arg name,weight,value
  i=input.0+1
  input.i=name'*'weight'*'value
  input.0=i
  Return
