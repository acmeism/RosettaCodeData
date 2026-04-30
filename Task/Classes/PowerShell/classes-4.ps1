$MyBanana   = [banana]::New()
$YourBanana = [banana]::New( $True )
$YourBanana.Ripen()
If ( -not $MyBanana.IsReadyToEat() -and $YourBanana.IsReadyToEat() )
    { $MySecondBanana = $YourBanana }
