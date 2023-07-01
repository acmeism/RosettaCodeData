function StepUp
    {
    If ( -not ( Step ) )
        {
        StepUp
        StepUp
        }
    }

#  Step simulator for testing
function Step
    {
    If ( Get-Random 0,1 )
        {
        $Success = $True
        Write-Verbose "Up one step"
        }
    Else
        {
        $Success = $False
        Write-Verbose "Fell one step"
        }
    return $Success
    }

#  Test
$VerbosePreference = 'Continue'
StepUp
