## Clear Host from old Ouput
Clear-Host

$Name = Read-Host "Please enter your name"
$Char = ($name.ToUpper())[0]
IF (($Char -eq "A") -or ($Char -eq "E") -or ($Char -eq "I") -or ($Char -eq "O") -or ($Char -eq "U"))
  {
    Write-Host "$Name, $Name, bo-b$($Name.ToLower())"
  }
else
  {
    IF ($Char -eq "B")
      {
        Write-Host "$Name, $Name, bo-$($Name.Substring(1))"
      }
    else
      {
        Write-Host "$Name, $Name, bo-b$($Name.Substring(1))"
      }
  }

  IF (($Char -eq "A") -or ($Char -eq "E") -or ($Char -eq "I") -or ($Char -eq "O") -or ($Char -eq "U"))
  {
    Write-Host "Banana-fana fo-f$($Name.ToLower())"
  }
else
  {
    IF ($Char -eq "F")
      {
        Write-Host "Banana-fana fo-$($Name.Substring(1))"
      }
    else
      {
        Write-Host "Banana-fana fo-f$($Name.Substring(1))"
      }
  }

  IF (($Name[0] -eq "A") -or ($Name[0] -eq "E") -or ($Name[0] -eq "I") -or ($Name[0] -eq "O") -or ($Name[0] -eq "U"))
  {
    Write-Host "Fee-fi-mo-m$($Name.tolower())"
  }
else
  {
    IF ($Char -eq "M")
      {
        Write-Host "Fee-fi-mo-$($Name.Substring(1))"
      }
    else
      {
        Write-Host "Fee-fi-mo-m$($Name.Substring(1))"
      }
  }
Write-Host "$Name"
