function Out-Example
{
    "Example"
}

function Step-Function ([string]$Function, [int]$Repeat)
{
    for ($i = 1; $i -le $Repeat; $i++)
    {
        "$(Invoke-Expression -Command $Function) $i"
    }
}

Step-Function Out-Example -Repeat 3
