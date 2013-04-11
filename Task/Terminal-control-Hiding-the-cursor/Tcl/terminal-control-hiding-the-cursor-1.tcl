proc cursor {{state "normal"}} {
    switch -- $state {
	"normal"    {set op "cnorm"}
	"invisible" {set op "civis"}
	"visible"   {set op "cvvis"}
    }
    # Should be just: “exec tput $op” but it's not actually supported on my terminal...
    exec sh -c "tput $op || true"
}
