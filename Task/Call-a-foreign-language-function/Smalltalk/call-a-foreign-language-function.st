Object subclass:'CallDemo'!
!CallDemo class methods!
strdup:arg
    <cdecl: mustFree char* 'strdup' (char*) module:'libc'>
! !

Transcript showCR:( CallDemo strdup:'Hello' )
