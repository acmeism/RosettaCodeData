; ModuleID = 'factorial.c'
; source_filename = "factorial.c"
; target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
; target triple = "x86_64-pc-windows-msvc19.21.27702"

; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

$"\01??_C@_04PEDNGLFL@?$CFld?6?$AA@" = comdat any

@"\01??_C@_04PEDNGLFL@?$CFld?6?$AA@" = linkonce_odr unnamed_addr constant [5 x i8] c"%ld\0A\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

; Function Attrs: noinline nounwind optnone uwtable
define i32 @factorial(i32) #0 {
;-- local copy of n
  %2 = alloca i32, align 4
;-- long result
  %3 = alloca i32, align 4
;-- int i
  %4 = alloca i32, align 4
;-- local n = parameter n
  store i32 %0, i32* %2, align 4
;-- result = 1
  store i32 1, i32* %3, align 4
;-- i = 1
  store i32 1, i32* %4, align 4
  br label %loop

loop:
;-- i <= n
  %5 = load i32, i32* %4, align 4
  %6 = load i32, i32* %2, align 4
  %7 = icmp sle i32 %5, %6
  br i1 %7, label %loop_body, label %exit

loop_body:
;-- result *= i
  %8 = load i32, i32* %4, align 4
  %9 = load i32, i32* %3, align 4
  %10 = mul nsw i32 %9, %8
  store i32 %10, i32* %3, align 4
  br label %loop_increment

loop_increment:
;-- ++i
  %11 = load i32, i32* %4, align 4
  %12 = add nsw i32 %11, 1
  store i32 %12, i32* %4, align 4
  br label %loop

exit:
;-- return result
  %13 = load i32, i32* %3, align 4
  ret i32 %13
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
;-- factorial(5)
  %1 = call i32 @factorial(i32 5)
;-- printf("%ld\n", factorial(5))
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @"\01??_C@_04PEDNGLFL@?$CFld?6?$AA@", i32 0, i32 0), i32 %1)
;-- return 0
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 6.0.1 (tags/RELEASE_601/final)"}
