#  Simulated fast function
function a ( [boolean]$J ) { return $J }

#  Simulated slow function
function b ( [boolean]$J ) { Sleep -Seconds 2; return $J }

#  These all short-circuit and do not evaluate the right hand function
( a $True  ) -or  ( b $False )
( a $True  ) -or  ( b $True  )
( a $False ) -and ( b $False )
( a $False ) -and ( b $True  )

#  Measure of execution time
Measure-Command {
( a $True  ) -or  ( b $False )
( a $True  ) -or  ( b $True  )
( a $False ) -and ( b $False )
( a $False ) -and ( b $True  )
} | Select TotalMilliseconds

#  These all appropriately do evaluate the right hand function
( a $False ) -or  ( b $False )
( a $False ) -or  ( b $True  )
( a $True  ) -and ( b $False )
( a $True  ) -and ( b $True  )

#  Measure of execution time
Measure-Command {
( a $False ) -or  ( b $False )
( a $False ) -or  ( b $True  )
( a $True  ) -and ( b $False )
( a $True  ) -and ( b $True  )
} | Select TotalMilliseconds
