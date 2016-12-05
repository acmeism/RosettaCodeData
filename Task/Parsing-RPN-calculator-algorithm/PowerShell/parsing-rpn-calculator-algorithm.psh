function Invoke-Rpn
{
  <#
    .SYNOPSIS
        A stack-based evaluator for an expression in reverse Polish notation.
    .DESCRIPTION
        A stack-based evaluator for an expression in reverse Polish notation.

        All methods in the Math and Decimal classes are available.
    .PARAMETER Expression
        A space separated, string of tokens.
    .PARAMETER DisplayState
        This switch shows the changes in the stack as each individual token is processed as a table.
    .EXAMPLE
        Invoke-Rpn -Expression "3 4 Max"
    .EXAMPLE
        Invoke-Rpn -Expression "3 4 Log2"
    .EXAMPLE
        Invoke-Rpn -Expression "3 4 2 * 1 5 - 2 3 ^ ^ / +"
    .EXAMPLE
        Invoke-Rpn -Expression "3 4 2 * 1 5 - 2 3 ^ ^ / +" -DisplayState
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string]
        $Expression,

        [Parameter(Mandatory=$false)]
        [switch]
        $DisplayState
    )
    Begin
    {
        function Out-State ([System.Collections.Stack]$Stack)
        {
            $array = $Stack.ToArray()
            [Array]::Reverse($array)
            $array | ForEach-Object -Process { Write-Host ("{0,-8:F3}" -f $_) -NoNewline } -End { Write-Host }
        }

        function New-RpnEvaluation
        {
            $stack = New-Object -Type System.Collections.Stack

            $shortcuts = @{
                "+" = "Add"; "-" = "Subtract"; "/" = "Divide"; "*" = "Multiply"; "%" = "Remainder"; "^" = "Pow"
            }

            :ARGUMENT_LOOP foreach ($argument in $args)
            {
                if ($DisplayState -and $stack.Count)
                {
                    Out-State $stack
                }

                if ($shortcuts[$argument])
                {
                    $argument = $shortcuts[$argument]
                }

                try
                {
                    $stack.Push([decimal]$argument)
                    continue
                }
                catch
                {
                }

                $argCountList = $argument -replace "(\D+)(\d*)",‘$2’
                $operation = $argument.Substring(0, $argument.Length – $argCountList.Length)

                foreach($type in [Decimal],[Math])
                {
                    if ($definition = $type::$operation)
                    {
                        if (-not $argCountList)
                        {
                            $argCountList = $definition.OverloadDefinitions |
                                Foreach-Object { ($_ -split ", ").Count } |
                                Sort-Object -Unique
                        }

                        foreach ($argCount in $argCountList)
                        {
                            try
                            {
                                $methodArguments = $stack.ToArray()[($argCount–1)..0]
                                $result = $type::$operation.Invoke($methodArguments)

                                $null = 1..$argCount | Foreach-Object { $stack.Pop() }

                                $stack.Push($result)

                                continue ARGUMENT_LOOP
                            }
                            catch
                            {
                                ## If error, try with the next number of arguments
                            }
                        }
                    }
                }
            }

            if ($DisplayState -and $stack.Count)
            {
                Out-State $stack
                if ($stack.Count)
                {
                    Write-Host "`nResult = $($stack.Peek())"
                }
            }
            else
            {
                $stack
            }
        }
    }
    Process
    {
        Invoke-Expression -Command "New-RpnEvaluation $Expression"
    }
    End
    {
    }
}

Invoke-Rpn -Expression "3 4 2 * 1 5 - 2 3 ^ ^ / +" -DisplayState
