; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

%struct._iobuf = type { i8* }

$"message" = comdat any
@"message" = linkonce_odr unnamed_addr constant [17 x i8] c"Goodbye, world!\0A\00", comdat, align 1

;-- For discovering stderr (io pipe 2)
declare %struct._iobuf* @__acrt_iob_func(i32)

;--- The declaration for the external C fprintf function.
declare i32 @fprintf(%struct._iobuf*, i8*, ...)

define i32 @main() {
;-- load stderr
  %1 = call %struct._iobuf* @__acrt_iob_func(i32 2)
;-- print the message to stderr with fprintf
  %2 = call i32 (%struct._iobuf*, i8*, ...) @fprintf(%struct._iobuf* %1, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @"message", i32 0, i32 0))
;-- exit
  ret i32 0
}
