$string = 'alphaBETA'
$lower  = $string.ToLower()
$upper  = $string.ToUpper()
$title  = (Get-Culture).TextInfo.ToTitleCase($string)

$lower, $upper, $title
