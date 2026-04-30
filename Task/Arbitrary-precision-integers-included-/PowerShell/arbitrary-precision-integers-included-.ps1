#  Perform calculation
$BigNumber = [BigInt]::Pow( 5, [BigInt]::Pow( 4, [BigInt]::Pow( 3, 2 ) ) )

#  Display first and last 20 digits
$BigNumberString = [string]$BigNumber
$BigNumberString.Substring( 0, 20 ) + "..." + $BigNumberString.Substring( $BigNumberString.Length - 20, 20 )

#  Display number of digits
$BigNumberString.Length
