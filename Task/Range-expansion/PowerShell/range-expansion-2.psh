function Expand-Range
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[0-9,-]*$')]
        [string]
        $Range
    )

    try
    {
        if ($Range -match '-,')       # I'm not good enough to weed this case out with Regex
        {
            throw "Input string was not in a correct format."
        }

        [int[]]$output = $Range -split ',' | ForEach-Object {

            [int[]]$array = $_ -split '(?<=\d)-'

            if ($array.Count -gt 1)   # $array contains one or two elements
            {
                $array[0]..$array[1]  # two elements = start and end of range
            }
            else
            {
                $array                # one element = an integer
            }
        }
    }
    catch
    {
        throw "Input string was not in a correct format."
    }

    $output
}
