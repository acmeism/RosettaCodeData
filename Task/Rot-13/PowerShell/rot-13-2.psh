function Invoke-Rot13 {
  param(
    [char[]]$message
  )
  begin {
    $outString = New-Object System.Collections.ArrayList
    $alpha = 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
    $alphaL = $alpha + $alpha
    $alphaU = $alphaL.toUpper()
    $int = 13
  }
  process{
    $message | ForEach-Object {
      # test if char is special
      if ($_ -match '[^\p{L}\p{Nd}]') {
        $outString += $_
      }
      # test if char is digit
      elseif ($_ -match '\d') {
        $outString += $_
      }
      # test if char is upperCase
      elseif ($_ -ceq $_.ToString().ToUpper()) {
        $charIndex = $alphaU.IndexOf($_.tostring())
        $outString += $alphaU[$charIndex+$int]
      }
      # test if char is lowerCase
      elseif ($_ -ceq $_.ToString().ToLower()) {
        $charIndex = $alphaL.IndexOf($_.tostring())
        $outString += $alphaL[$charIndex+$int]
      }
      else {
        $outString += $_
      }
    } # end foreach
  } # end process
  end {
    # output string and join all chars
    $outString -join ""
  }
} # end function
