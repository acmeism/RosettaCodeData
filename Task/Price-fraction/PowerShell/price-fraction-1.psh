function Convert-PriceFraction
{
    [CmdletBinding()]
    [OutputType([double])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateScript({$_ -ge 0.0 -and $_ -le 1.0})]
        [double]
        $InputObject
    )

    Process
    {
        foreach ($fraction in $InputObject)
        {
            switch ($fraction)
            {
                {$_ -lt 0.06} {0.10; break}
                {$_ -lt 0.11} {0.18; break}
                {$_ -lt 0.16} {0.26; break}
                {$_ -lt 0.21} {0.32; break}
                {$_ -lt 0.26} {0.38; break}
                {$_ -lt 0.31} {0.44; break}
                {$_ -lt 0.36} {0.50; break}
                {$_ -lt 0.41} {0.54; break}
                {$_ -lt 0.46} {0.58; break}
                {$_ -lt 0.51} {0.62; break}
                {$_ -lt 0.56} {0.66; break}
                {$_ -lt 0.61} {0.70; break}
                {$_ -lt 0.66} {0.74; break}
                {$_ -lt 0.71} {0.78; break}
                {$_ -lt 0.76} {0.82; break}
                {$_ -lt 0.81} {0.86; break}
                {$_ -lt 0.86} {0.90; break}
                {$_ -lt 0.91} {0.94; break}
                {$_ -lt 0.96} {0.98; break}
                Default       {1.00}
            }
        }
    }
}
