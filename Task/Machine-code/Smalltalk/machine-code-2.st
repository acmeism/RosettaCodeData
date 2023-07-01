OperatingSystem getCPUType = #'x86' ifTrue:[
    code := #[0x8B 0x44 0x24 0x04 0x03 0x44 0x24 0x08 0xC3].
] ifFalse:[
    self error:'unsupported cpu'
].

handle := ExternalBytes mapExecutableBytes:100.
handle replaceFrom:1 with:code.

" dump it (debugging only)... "
e'code at {handle address hexPrintString} is:' printCR.
(handle copyFrom:1 to:50) asByteArray hexPrintString printCR.

" create an ExternalFunction for it "
func := ExternalLibraryFunction new code:handle address.
func name:'unnamed' module:nil returnType:#int argumentTypes:#(int int).
func beCallTypeC.
func printCR.

" now call it "
result := func invokeWithArguments:{10 . 20}
