### Clear Screen from old Output
Clear-Host

Function RandomOpening ()
  {
    $Prisoners = 1..100 | Sort-Object {Get-Random}
    $Cupboard = 1..100 | Sort-Object {Get-Random}
    ## Loop for the Prisoners
    $Survived = $true
    for ($I=1;$I -le 100;$i++)
      {
          $OpeningListe = 1..100 | Sort-Object {Get-Random}
          $Gefunden = $false
          ## Loop for the trys of every prisoner
          for ($X=1;$X -le 50;$X++)
            {
                $OpenNumber = $OpeningListe[$X]
                IF ($Cupboard[$OpenNumber] -eq $Prisoners[$I])
                  {
                      $Gefunden = $true
                  }
                ## Cancel loop if prisoner found his number (yeah i know, dirty way ^^ )
                IF ($Gefunden)
                  {
                    $X = 55
                  }
            }
          IF ($Gefunden -eq $false)
            {
              $I = 120
              $Survived = $false
            }
      }
    Return $Survived
  }

  Function StrategyOpening ()
  {
    $Prisoners = 1..100 | Sort-Object {Get-Random}
    $Cupboard = 1..100 | Sort-Object {Get-Random}
    $Survived = $true
    for ($I=1;$I -le 100;$i++)
      {
          $Gefunden = $false
          $OpeningNumber = $Prisoners[$I-1]
          for ($X=1;$X -le 50;$X++)
            {
                IF ($Cupboard[$OpeningNumber-1] -eq $Prisoners[$I-1])
                  {
                      $Gefunden = $true
                  }
                else
                  {
                    $OpeningNumber = $Cupboard[$OpeningNumber-1]
                  }
                IF ($Gefunden)
                  {
                    $X = 55
                  }
            }
          IF ($Gefunden -eq $false)
            {
              $I = 120
              $Survived = $false
            }
      }
    Return $Survived
  }

$MaxRounds = 10000

Function TestRandom
  {
    $WinnerRandom = 0
    for ($Round = 1; $Round -le $MaxRounds;$Round++)
      {
        IF (($Round%1000) -eq 0)
          {
            $Time = Get-Date
            Write-Host "Currently we are at rount $Round at $Time"
          }
        $Rueckgabewert = RandomOpening
        IF ($Rueckgabewert)
          {
            $WinnerRandom++
          }
      }

    $Prozent = (100/$MaxRounds)*$WinnerRandom
    Write-Host "There are $WinnerRandom survivors whit random opening. This is $Prozent percent"
  }

Function TestStrategy
  {
    $WinnersStrategy = 0
      for ($Round = 1; $Round -le $MaxRounds;$Round++)
        {
          IF (($Round%1000) -eq 0)
            {
              $Time = Get-Date
              Write-Host "Currently we are at $Round at $Time"
            }
          $Rueckgabewert = StrategyOpening
          IF ($Rueckgabewert)
            {
              $WinnersStrategy++
            }
        }

    $Prozent = (100/$MaxRounds)*$WinnersStrategy
    Write-Host "There are $WinnersStrategy survivors whit strategic opening. This is $Prozent percent"
  }

Function Main ()
  {
    Clear-Host
    TestRandom
    TestStrategy
  }

Main
