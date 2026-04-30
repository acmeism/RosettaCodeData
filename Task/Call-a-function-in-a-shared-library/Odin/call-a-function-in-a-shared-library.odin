package beep
foreign import kernel32 "system:kernel32.lib"

main :: proc() {
	// Declare function in foreign block
    foreign kernel32 {
	    @(link_name="Beep")      Beep      :: proc(x,y: u32) -> bool ---
    }
    // Calling Beep function
    // https://learn.microsoft.com/en-us/windows/win32/api/utilapiset/nf-utilapiset-beep
    // Beep(Frequency,Duration)
    Beep( 750, 300 )
}
