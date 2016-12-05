$file =
@'
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
'@.Split("`n")

$arr = @()
$file | foreach {
    $line = $_
    $i = 0
    $hash = [ordered]@{}
    $line.split('$') | foreach{
        $hash["$i"] = "$_"
        $i++
     }
    $arr += @([pscustomobject]$hash)
}
$arr | Format-Table -HideTableHeaders -Wrap *
