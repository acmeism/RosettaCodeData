$options = @{
        opt1 = [bool] 0
        opt2 = [bool] 0
        opt3 = [bool] 0
    }
$help = @"
    FUNCTION usage: FUNCTION [-p] [-w] [-h] [-c] <int><float><string>PARAMETERS...

    Lorem Ipsum blah blah blah

    NOTE something yada yada

    Options:
        -p,--pxx    Name    Some option that has significance with the letter 'p'
        -w,--wxx    Name    Some option that has significance with the letter 'w'
        -c,--cxx    Name    Some option that has significance with the letter 'c'
        -h,--help   Help    Prints this message
"@

    function parseOptions ($argv,$options) {
        $opts = @()
        if (!$argv) { return $null }
        foreach ($arg in $argv) {
            # Make sure the argument is something you are expecting
            $test = ($arg -is [int]) -or
                    ($arg -is [string]) -or
                    ($arg -is [float])
            if (!$test) {
                Write-Host "Bad argument: $arg is not an integer, float, nor string." -ForegroundColor Red
                throw "Error: Bad Argument"
            }
            if ($arg -like '-*') { $opts += $arg }
        }
        $argv = [Collections.ArrayList]$argv
        if ($opts) {
            foreach ($opt in $opts) {
                switch ($opt) {
                    {'-p' -or '--pxx'}   { $options.opt1 = [bool] 1 }
                    {'-w' -or '--wxx'}   { $options.opt2 = [bool] 1 }
                    {'-c' -or '--cxx'}   { $options.opt3 = [bool] 1 }
                    {'-h' -or '--help'}  { Write-Host $help -ForegroundColor Cyan; break 1 }
                    default {
                        Write-Host "Bad option: $opt is not a valid option." -ForegroundColor Red
                        throw "Error: Bad Option"
                    }
                }
            $argv.Remove($opt)
            }
        }
        return [array]$argv,$options
    }#fn
