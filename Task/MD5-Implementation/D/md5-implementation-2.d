module zmd5 ;
private import md5asm ;

/*
  duplicated codes from standard module
*/

    private void transform(ubyte* block) {

        uint[16] x;

        Decode (x.ptr, block, 64);

        auto pState  = state.ptr ;
        auto pBuffer = x.ptr ;

        asm{
            mov     ESI, pState[EBP] ;
            mov     EDX,[ESI + 3*4] ;
            mov     ECX,[ESI + 2*4] ;
            mov     EBX,[ESI + 1*4] ;
            mov     EAX,[ESI + 0*4] ;
            push    EBP ;
            push    ESI ;

            mov     EBP, pBuffer[EBP] ;
        }

        mixin("asm { "~md5asm.Transform~"}") ;

        asm{
            pop     ESI ;
            pop     EBP ;
            add     [ESI + 0*4],EAX ;
            add     [ESI + 1*4],EBX ;
            add     [ESI + 2*4],ECX ;
            add     [ESI + 3*4],EDX ;
        }
        x[] = 0 ;
    }

/*
  duplicated codes from standard module
*/
