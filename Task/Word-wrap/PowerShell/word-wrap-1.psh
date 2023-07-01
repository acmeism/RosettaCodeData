function wrap{
$divide=$args[0] -split " "
$width=$args[1]
$spaceleft=$width

foreach($word in $divide){
    if($word.length+1 -gt $spaceleft){
        $output+="`n$word "
        $spaceleft=$width-($word.length+1)
    } else {
        $output+="$word "
        $spaceleft-=$word.length+1
    }
}

return "$output`n"
}

### The Main Thing...

$paragraph="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

"`nLine width:30`n"
wrap $paragraph 30
"========================================================="
"Line width:100`n"
wrap $paragraph 100

### End script
