1..100|foreach-object {$pipe += "toggle $_ |"} -begin {$pipe=""}
filter toggle($pass) {$_.door = $_.door -xor !($_.index % $pass);$_}
invoke-expression "1..100| foreach-object {@{index=`$_;door=`$false}} | $pipe  out-host"
