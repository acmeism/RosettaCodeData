$paramLists = @(@{Name='mary'; Female=$true; Item="little lamb"},
                @{Name='hank'; Male=$true; Item="shank"},
                @{Name='foo'; Male=$true; Item="bar"})

foreach ($paramList in $paramLists)
{
    New-MadLibs @paramList
}
