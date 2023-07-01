function TestDepth ( $N )
    {
    $N
    TestDepth ( $N + 1 )
    }

try
    {
    TestDepth 1 | ForEach { $Depth = $_ }
    }
catch
    {
    "Exception message: " + $_.Exception.Message
    }
"Last level before error: " + $Depth
