proc speak {msg} {
    global tcl_platform
    if {$tcl_platform(platform) eq "windows"} {
        package require tcom
        set voice [::tcom::ref createobject Sapi.SpVoice]
        $voice Speak $msg 0
    } elseif {$tcl_platform(os) eq "Darwin"} {
        exec say << $msg
    } else {
        exec festival --tts << $msg
    }
}
speak "This is an example of speech synthesis."
