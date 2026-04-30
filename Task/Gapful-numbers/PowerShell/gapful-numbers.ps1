function Get-FirstDigit {
  param ( [int] $Number )
  [int]$Number.ToString().Substring(0,1)
}

function Get-LastDigit {
  param ( [int] $Number )
  $Number % 10
}

function Get-BookendNumber {
  param ( [Int] $Number )
  10 * (Get-FirstDigit $Number) + (Get-LastDigit $Number)
}

function Test-Gapful {
  param ( [Int] $Number )
  100 -lt $Number -and 0 -eq $Number % (Get-BookendNumber $Number)
}

function Find-Gapfuls {
  param ( [Int] $Start, [Int] $Count )
  $result = @()

  While ($result.Count -lt $Count)  {
    If (Test-Gapful $Start) {
      $result += @($Start)
    }
    $Start += 1
  }
  return $result
}

function Search-Range {
  param ( [Int] $Start, [Int] $Count )
  Write-Output "The first $Count gapful numbers >= $($Start):"
  Write-Output( (Find-Gapfuls $Start $Count) -join ",")
  Write-Output ""
}

Search-Range 1 30
Search-Range 1000000 15
Search-Range 1000000000 10
