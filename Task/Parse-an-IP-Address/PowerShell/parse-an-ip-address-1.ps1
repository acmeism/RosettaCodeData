function Get-IpAddress
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $InputObject
    )

    Begin
    {
        function Get-Address ([string]$Address)
        {
            if ($Address.IndexOf(".") -ne -1)
            {
                $Address, $port = $Address.Split(":")

                [PSCustomObject]@{
                    IPAddress = [System.Net.IPAddress]$Address
                    Port      = $port
                }
            }
            else
            {
                if ($Address.IndexOf("[") -ne -1)
                {
                    [PSCustomObject]@{
                        IPAddress = [System.Net.IPAddress]$Address
                        Port      = ($Address.Split("]")[-1]).TrimStart(":")
                    }
                }
                else
                {
                    [PSCustomObject]@{
                        IPAddress = [System.Net.IPAddress]$Address
                        Port      = $null
                    }
                }
            }
        }
    }
    Process
    {
        $InputObject | ForEach-Object {
            $address = Get-Address $_
            $bytes = ([System.Net.IPAddress]$address.IPAddress).GetAddressBytes()
            [Array]::Reverse($bytes)
            $i = 0
            $bytes | ForEach-Object -Begin   {[bigint]$decimalIP = 0} `
                                    -Process {$decimalIP += [bigint]$_ * [bigint]::Pow(256, $i); $i++} `
                                    -End     {[PSCustomObject]@{
                                                  Address = $address.IPAddress
                                                  Port    = $address.Port
                                                  Hex     = "0x$($decimalIP.ToString('x'))"}
                                             }
        }
    }
}
