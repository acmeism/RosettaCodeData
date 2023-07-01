$a = "aeiou`u{0308}yz"
$enum = [System.Globalization.StringInfo]::GetTextElementEnumerator($a)
$arr = @()
while($enum.MoveNext()) { $arr += $enum.GetTextElement() }
[array]::reverse($arr)
$arr -join '' # zyüoiea
