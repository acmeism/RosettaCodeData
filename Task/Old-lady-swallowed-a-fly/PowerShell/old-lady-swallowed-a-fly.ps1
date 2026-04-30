$lines = @(
    'fly/'
    'spider/That wiggled and jiggled and tickled inside her,'
    'bird/How absurd, to swallow a bird,'
    'cat/Imagine that. She swallowed a cat,'
    'dog/What a hog to swallow a dog,'
    'goat/She just opened her throat and swallowed that goat,'
    'cow/I don''t know how she swallowed that cow,'
    'horse/She''s dead of course!'
)

$eatenThings = @()

for($i=0; $i -lt $lines.Count; $i++)
{
    $creature, $comment = $lines[$i].Split("/")
    $eatenThings += $creature

    "I know an old lady who swallowed a $creature,"

    if ($comment) {$comment}
    if ($i -eq ($lines.Count - 1)) {continue}
	
    for($j=$i; $j -ge 1; $j--)
    {
        "She swallowed the {0} to catch the {1}," -f $eatenThings[$j, ($j-1)]
    }

	"I don't know why she swallowed the fly."
	"Perhaps she'll die."
	""
}
