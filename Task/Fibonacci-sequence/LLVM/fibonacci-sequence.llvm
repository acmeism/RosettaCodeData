; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

$"PRINT_LONG" = comdat any
@"PRINT_LONG" = linkonce_odr unnamed_addr constant [5 x i8] c"%ld\0A\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

;--------------------------------------------------------------------
;-- Function for calculating the nth fibonacci numbers
;--------------------------------------------------------------------
define i32 @fibonacci(i32) {
    %2 = alloca i32, align 4            ;-- allocate local copy of n
    %3 = alloca i32, align 4            ;-- allocate a
    %4 = alloca i32, align 4            ;-- allocate b
    store i32 %0, i32* %2, align 4      ;-- store copy of n
    store i32 0, i32* %3, align 4       ;-- a := 0
    store i32 1, i32* %4, align 4       ;-- b := 1
    br label %loop

loop:
    %5 = load i32, i32* %2, align 4     ;-- load n
    %6 = icmp sgt i32 %5, 0             ;-- n > 0
    br i1 %6, label %loop_body, label %exit

loop_body:
    %7 = load i32, i32* %3, align 4     ;-- load a
    %8 = load i32, i32* %4, align 4     ;-- load b
    %9 = add nsw i32 %7, %8             ;-- t = a + b
    store i32 %8, i32* %3, align 4      ;-- store a = b
    store i32 %9, i32* %4, align 4      ;-- store b = t
    %10 = load i32, i32* %2, align 4    ;-- load n
    %11 = add nsw i32 %10, -1           ;-- decrement n
    store i32 %11, i32* %2, align 4     ;-- store n
    br label %loop

exit:
    %12 = load i32, i32* %3, align 4    ;-- load a
    ret i32 %12                         ;-- return a
}

;--------------------------------------------------------------------
;-- Main function for printing successive fibonacci numbers
;--------------------------------------------------------------------
define i32 @main() {
    %1 = alloca i32, align 4            ;-- allocate index
    store i32 0, i32* %1, align 4       ;-- index := 0
    br label %loop

loop:
    %2 = load i32, i32* %1, align 4     ;-- load index
    %3 = icmp sle i32 %2, 12            ;-- index <= 12
    br i1 %3, label %loop_body, label %exit

loop_body:
    %4 = load i32, i32* %1, align 4     ;-- load index
    %5 = call i32 @fibonacci(i32 %4)
    %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @"PRINT_LONG", i32 0, i32 0), i32 %5)
    %7 = load i32, i32* %1, align 4     ;-- load index
    %8 = add nsw i32 %7, 1              ;-- increment index
    store i32 %8, i32* %1, align 4      ;-- store index
    br label %loop

exit:
    ret i32 0                           ;-- return EXIT_SUCCESS
}
