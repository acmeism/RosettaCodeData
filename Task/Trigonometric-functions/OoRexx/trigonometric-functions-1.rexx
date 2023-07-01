/* REXX ---------------------------------------------------------------
* show how the functions can be used
* 03.05.2014 Walter Pachl
*--------------------------------------------------------------------*/
Say 'Default precision:'  .locaL~my.rxm~precision()
Say 'Default type:     '  .locaL~my.rxm~type()
Say 'rxmsin(60)      ='rxmsin(60)     -- use default precision and type
Say 'rxmsin(1,21,"R")='rxmsin(1,21,'R') -- precision and type specified
Say 'rxmlog(-1)      ='rxmlog(-1)
Say 'rxmlog( 0)      ='rxmlog( 0)
Say 'rxmlog( 1)      ='rxmlog( 1)
Say 'rxmlog( 2)      ='rxmlog( 2)
  .locaL~my.rxm~precision=50
  .locaL~my.rxm~type='R'
Say 'Changed precision:'    .locaL~my.rxm~precision()
Say 'Changed type:     '    .locaL~my.rxm~type()
Say 'rxmsin(1)       ='rxmsin(1)        -- use changed precision and type
::requires rxm.cls
