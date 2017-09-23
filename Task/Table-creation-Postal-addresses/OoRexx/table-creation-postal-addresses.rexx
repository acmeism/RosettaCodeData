/* REXX ***************************************************************
* 17.05.2013 Walter Pachl  translated from REXX version 2
* nice try? improvements are welcome as I am rather unexperienced
* 18.05.2013 the array may contain a variety of objects!
**********************************************************************/
alist=.array~new
alist[1]=.addr~new('Boston','MA','51 Franklin Street',,'FSF Inc.',,
                                                          '02110-1301')
alist[2]='not an address at all'
alist[3]=.addr~new('Washington','DC','The Oval Office',,
                 '1600 Pennsylvania Avenue NW','The White House',20500)
Do i=1 To alist~items
  a=alist[i]
  If a~isinstanceof(.addr) Then
    a~show
  End

::class addr
  ::attribute city
  ::attribute state
  ::attribute addr
  ::attribute addr2
  ::attribute name
  ::attribute zip

::method init
  Parse Arg self~city,,
            self~state,,
            self~addr,,
            self~addr2,,
            self~name,,
            self~zip

::method show
                         Say '  name -->' self~name
                         Say '  addr -->' self~addr
  If self~addr2<>'' Then Say ' addr2 -->' self~addr2
                         Say '  city -->' self~city
                         Say ' state -->' self~state
                         Say '   zip -->' self~zip
  Say copies('-',40)
