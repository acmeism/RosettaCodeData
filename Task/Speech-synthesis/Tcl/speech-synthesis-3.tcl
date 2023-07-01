package require tcom

set msg "This is an example of speech synthesis."
set voice [::tcom::ref createobject Sapi.SpVoice]
$voice Speak $msg 0
