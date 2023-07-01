coclass 'delegator'
  operation=:3 :'thing__delegate ::thing y'
  thing=: 'default implementation'"_
  setDelegate=:3 :'delegate=:y'  NB. result is the reference to our new delegate
  delegate=:<'delegator'

coclass 'delegatee1'

coclass 'delegatee2'
  thing=: 'delegate implementation'"_

NB. set context in case this script was used interactively, instead of being loaded
cocurrent 'base'
