function New-MadLibs
{
    [CmdletBinding(DefaultParameterSetName='None')]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]
        $Name = "",

        [Parameter(Mandatory=$false, ParameterSetName='Male')]
        [switch]
        $Male,

        [Parameter(Mandatory=$false, ParameterSetName='Female')]
        [switch]
        $Female,

        [Parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]
        $Item = ""
    )

    if (-not $Name)
    {
        $Name = (Get-Culture).TextInfo.ToTitleCase((Read-Host -Prompt "`nEnter a name").ToLower())
    }
    else
    {
        $Name = (Get-Culture).TextInfo.ToTitleCase(($Name).ToLower())
    }

    if ($Male)
    {
        $pronoun = "He"
    }
    elseif ($Female)
    {
        $pronoun = "She"
    }
    else
    {
        $title   = "Gender"
        $message = "Select $Name's Gender"
        $_male   = New-Object System.Management.Automation.Host.ChoiceDescription "&Male", "Selects male gender."
        $_female = New-Object System.Management.Automation.Host.ChoiceDescription "&Female", "Selects female gender."
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($_male, $_female)
        $result  = $host.UI.PromptForChoice($title, $message, $options, 0)

        switch ($result)
        {
            0 {$pronoun = "He"}
            1 {$pronoun = "She"}
        }
    }

    if (-not $Item)
    {
        $Item = Read-Host -Prompt "`nEnter an item"
    }

    "`n{0} went for a walk in the park. {1} found a {2}. {0} decided to take it home.`n" -f $Name, $pronoun, $Item
}
