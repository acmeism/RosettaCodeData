function Get-ISBN13 {
    $codes = (
        "978-0596528126",
        "978-0596528120",
        "978-1788399081",
        "978-1788399083"
    )

    foreach ($line in $codes) {

        $sum = $null
        $codeNoDash = $line.Replace("-","")

        for ($i = 0; $i -lt $codeNoDash.length; $i++) {

            if (($i % 2) -eq 1) {

                $sum += [decimal]$codeNoDash[$i] * 3

            }else {

                $sum += [decimal]$codeNoDash[$i]

            }
        }

        if (($sum % 10) -eq 0) {

            Write-Host "$line Good"

        }else {

            Write-Host "$line Bad"

        }
    }
}
Get-ISBN13
