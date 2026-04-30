<#
.Synopsis
   Gets the difference between two angles between the values of -180 and 180.
   To see examples use "Get-Examples"
.DESCRIPTION
   This code uses the modulo operator, this is represented with the "%".
   The  modulo operator returns the remainder after division, as displayed below
   3 % 2 = 1
   20 % 15 = 5
   200 % 146 = 54

.EXAMPLE
    PS C:\WINDOWS\system32> Get-AngleDiff
    cmdlet Get-AngleDiff at command pipeline position 1
    Supply values for the following parameters:
    angle1: 45
    angle2: -85

    The difference between 45 and -85 is -130

    PS C:\WINDOWS\system32>

.EXAMPLE
    PS C:\WINDOWS\system32> Get-AngleDiff -angle1 50 -angle2 -65

    The difference between 50 and -65 is -115

    PS C:\WINDOWS\system32>

.EXAMPLE
    PS C:\WINDOWS\system32> Get-AngleDiff -89 50

    The difference between -89 and 50 is 139

    PS C:\WINDOWS\system32>


#>
function Get-AngleDiff
{
    [CmdletBinding()]

    Param
    (
        # Angle one input, must be a number
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)][double]$angle1,

        # Angle two input, must be a number
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)][double]$angle2
                   )

    Begin
    {
    #This is the equation to calculate the difference
    [double]$Difference = ($angle2 - $angle1) % 360.0
    }

    Process
    {
    #If/IfElse/Else block to return results within the requested range
    if ($Difference -lt -180.0)
        {$Difference += 360.0
        }

    elseif ($Difference -gt 360.0)
        {$Difference -= 360.0
        }

    #Writes the values given by the user and the result
    Write-Host "The difference between $angle1 and $angle2 is $Difference"
    }

    End
    {
    }

}

<#
.Synopsis
   This is simply the outputs of the Get-AngleDiff Function in a function
.EXAMPLE
PS C:\WINDOWS\system32> Get-Examples

Inputs from the -180 to 180 range
The difference between 20 and 45 is 25
The difference between -45 and 45 is 90
The difference between -85 and 90 is 175
The difference between -95 and 90 is 185
The difference between -45 and 125 is 170
The difference between -45 and 145 is 190
The difference between -45 and 125 is 170
The difference between -45 and 145 is 190
The difference between 29.4803 and -88.6381 is -118.1184
The difference between -78.3251 and -159.036 is -80.7109

Inputs from a wider range
The difference between -70099.7423381094 and 29840.6743787672 is 220.416716876614
The difference between -165313.666629736 and 33693.9894517456 is 287.656081481313
The difference between 1174.83805105985 and -154146.664901248 is -161.502952307404
The difference between 60175.7730679555 and 42213.0719235437 is 37.2988555882694

PS C:\WINDOWS\system32>
#>

function Get-Examples
{
    #blank write-host is used for a blank line to make the output look a lil cleaner
    Write-Host
    Write-Host "Inputs from the -180 to 180 range"

    Get-AngleDiff 20.0 45.0
    Get-AngleDiff -45.0 45.0
    Get-AngleDiff -85.0 90.0
    Get-AngleDiff -95.0 90.0
    Get-AngleDiff -45.0 125.0
    Get-AngleDiff -45.0 145.0
    Get-AngleDiff -45.0 125.0
    Get-AngleDiff -45.0 145.0
    Get-AngleDiff 29.4803 -88.6381
    Get-AngleDiff -78.3251 -159.036

    Write-Host
    Write-Host "Inputs from a wider range"

    Get-AngleDiff -70099.74233810938 29840.67437876723
    Get-AngleDiff -165313.6666297357 33693.9894517456
    Get-AngleDiff 1174.8380510598456 -154146.66490124757
    Get-AngleDiff 60175.77306795546 42213.07192354373


}
