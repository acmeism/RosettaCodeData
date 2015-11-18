Function msstate{
    Param($current_seed)
    Return (214013*$current_seed+2531011)%2147483648}

Function randMS{
    Param($MSState)
    Return [int]($MSState/65536)}

Function randBSD{
    Param($BSDState)
    Return (1103515245*$BSDState+12345)%2147483648}

Write-Host "MS: seed=0"
$seed=0 #initialize seed
For($i=1;$i-le5;$i++){
    $seed = msstate($seed)
    $rand = randMS($seed)
    Write-Host $rand}

Write-Host "BSD: seed=0"
$seed=0 #initialize seed
For($j=1;$j-le5;$j++){
    $seed = randBSD($seed)
    Write-Host $seed}
