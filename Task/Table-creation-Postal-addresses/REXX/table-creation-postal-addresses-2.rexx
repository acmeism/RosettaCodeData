/* REXX ***************************************************************
* 17.05.2013 Walter Pachl
* should work with every REXX.
* I use 0xxx for the tail because this can't be modified
**********************************************************************/
USA.=''; USA.0=0
Call add_usa 'Boston','MA','51 Franklin Street',,'FSF Inc.',,
                                                           '02110-1301'
Call add_usa 'Washington','DC','The Oval Office',,
                  '1600 Pennsylvania Avenue NW','The White House',20500
call list_usa
Exit

add_usa:
z=usa.0+1
Parse Arg usa.z.0city,,
          usa.z.0state,,
          usa.z.0addr,,
          usa.z.0addr2,,
          usa.z.0name,,
          usa.z.0zip
usa.0=z
Return

list_usa:
Do z=1 To usa.0
                           Say '  name -->' usa.z.0name
                           Say '  addr -->' usa.z.0addr
  If usa.z.0addr2<>'' Then Say ' addr2 -->' usa.z.0addr2
                           Say '  city -->' usa.z.0city
                           Say ' state -->' usa.z.0state
                           Say '   zip -->' usa.z.0zip
  Say copies('-',40)
  End
Return
