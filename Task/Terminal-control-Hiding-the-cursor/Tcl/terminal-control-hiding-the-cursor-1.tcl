proc cursorVisibility {{state normal}} {
    switch -- $state {
	invisible {set op civis}
	visible   {set op cvvis}
	normal    {set op cnorm}
    }
    exec -- >@stdout tput $op
}
