function Expand-Braces ( [string]$String )
    {
    $Escaped = $False
    $Stack = New-Object System.Collections.Stack
    $ClosedBraces = $BracesToParse = $Null

    ForEach ( $i in 0..($String.Length-1) )
        {
        Switch ( $String[$i] )
            {
            '\' {
                $Escaped = -not $Escaped
                break
                }

            '{' {
                If ( -not $Escaped ) { $Stack.Push( [pscustomobject]@{ Delimiters = @( $i ) } ) }
                }

            ',' {
                If ( -not $Escaped -and $Stack.Count ) { $Stack.Peek().Delimiters += $i }
                }

            '}' {
                If ( -not $Escaped -and $Stack.Count )
                    {
                    $Stack.Peek().Delimiters += $i
                    $ClosedBraces = $Stack.Pop()
                    If ( $ClosedBraces.Delimiters.Count -gt 2 )
                        {
                        $BracesToParse = $ClosedBraces
                        }
                    }
                }

            default { $Escaped = $False }
            }
        }

        If ( $BracesToParse )
            {
            $Start = $String.Substring( 0, $BracesToParse.Delimiters[0] )
            $End   = $String.Substring( $BracesToParse.Delimiters[-1] + 1 )

            ForEach ( $i in 0..($BracesToParse.Delimiters.Count-2) )
                {
                $Option = $String.Substring( $BracesToParse.Delimiters[$i] + 1, $BracesToParse.Delimiters[$i+1] - $BracesToParse.Delimiters[$i] - 1 )
                Expand-Braces ( $Start + $Option + $End )
                }
            }
        Else
            {
            $String
            }
    }
