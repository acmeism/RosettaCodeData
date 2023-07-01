$Name = 'fibo tribo tetra penta hexa hepta octo nona deca'.Split()
0..($Name.Length-1) | foreach { $Index = $_
    $InitialValues = @(1) + @(foreach ($I In 0..$Index) { [Math]::Pow(2,$I) })
    $Generator = Get-ExtendedFibonaciGenerator $InitialValues
    [PSCustomObject] @{
        n        = $InitialValues.Length;
        Name     = "$($Name[$Index])naci";
        Sequence = 1..15 | foreach { & $Generator } | Join-String -Separator ','
    }
} | Format-Table -AutoSize
