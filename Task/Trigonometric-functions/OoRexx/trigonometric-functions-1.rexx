/* REXX ---------------------------------------------------------------
* show how the functions can be used
* 03.05.2014 Walter Pachl
* 23.12.2024 Walter Pachl
*--------------------------------------------------------------------*/
Say 'Default precision:'  .locaL~my.rxm~precision()
Say 'Default type:     '  .locaL~my.rxm~type()
Say 'rxmsin(60,21,"D") ='rxmsin(60,21,"D") --  precision and type specified
Say 'rxmsin(1)         ='rxmsin(1)                 -- use default precision and type
Say 'rxmlog(-1)        ='rxmlog(-1)
Say 'rxmlog( 0)        ='rxmlog( 0)
Say 'rxmlog( 1)        ='rxmlog( 1)
Say 'rxmlog( 2)        ='rxmlog( 2)
  .locaL~my.rxm~precision=16
  .locaL~my.rxm~type='D'
Say 'Changed precision:'    .locaL~my.rxm~precision()
Say 'Changed type:     '    .locaL~my.rxm~type()
Say 'rxmsin(90)        ='rxmsin(90)        -- use changed precision and type
::requires rxm.cls
