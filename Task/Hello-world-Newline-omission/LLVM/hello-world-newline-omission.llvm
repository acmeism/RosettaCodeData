; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

$"OUTPUT_STR" = comdat any
@"OUTPUT_STR" = linkonce_odr unnamed_addr constant [16 x i8] c"Goodbye, World!\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

define i32 @main() {
    %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @"OUTPUT_STR", i32 0, i32 0))
    ret i32 0
}
