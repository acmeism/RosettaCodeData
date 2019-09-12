; ModuleID = 'fizzbuzz.c'
; source_filename = "fizzbuzz.c"
; target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
; target triple = "x86_64-pc-windows-msvc19.21.27702"

; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

$"\01??_C@_09NODAFEIA@FizzBuzz?6?$AA@" = comdat any
$"\01??_C@_05KEBFOHOF@Fizz?6?$AA@" = comdat any
$"\01??_C@_05JKJENPHA@Buzz?6?$AA@" = comdat any
$"\01??_C@_03PMGGPEJJ@?$CFd?6?$AA@" = comdat any

;--- String constant defintions
@"\01??_C@_09NODAFEIA@FizzBuzz?6?$AA@" = linkonce_odr unnamed_addr constant [10 x i8] c"FizzBuzz\0A\00", comdat, align 1
@"\01??_C@_05KEBFOHOF@Fizz?6?$AA@" = linkonce_odr unnamed_addr constant [6 x i8] c"Fizz\0A\00", comdat, align 1
@"\01??_C@_05JKJENPHA@Buzz?6?$AA@" = linkonce_odr unnamed_addr constant [6 x i8] c"Buzz\0A\00", comdat, align 1
@"\01??_C@_03PMGGPEJJ@?$CFd?6?$AA@" = linkonce_odr unnamed_addr constant [4 x i8] c"%d\0A\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 1, i32* %1, align 4
;--- It does not seem like this branch can be removed
  br label %loop

;--- while (i <= 100)
loop:
  %2 = load i32, i32* %1, align 4
  %3 = icmp sle i32 %2, 100
  br i1 %3, label %divisible_15, label %finished

;--- if (i % 15 == 0)
divisible_15:
  %4 = load i32, i32* %1, align 4
  %5 = srem i32 %4, 15
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %print_fizzbuzz, label %divisible_3

;--- Print 'FizzBuzz'
print_fizzbuzz:
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @"\01??_C@_09NODAFEIA@FizzBuzz?6?$AA@", i32 0, i32 0))
  br label %next

;--- if (i % 3 == 0)
divisible_3:
  %8 = load i32, i32* %1, align 4
  %9 = srem i32 %8, 3
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %print_fizz, label %divisible_5

;--- Print 'Fizz'
print_fizz:
  %11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @"\01??_C@_05KEBFOHOF@Fizz?6?$AA@", i32 0, i32 0))
  br label %next

;--- if (i % 5 == 0)
divisible_5:
  %12 = load i32, i32* %1, align 4
  %13 = srem i32 %12, 5
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %print_buzz, label %print_number

;--- Print 'Buzz'
print_buzz:
  %15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @"\01??_C@_05JKJENPHA@Buzz?6?$AA@", i32 0, i32 0))
  br label %next

;--- Print the number
print_number:
  %16 = load i32, i32* %1, align 4
  %17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"\01??_C@_03PMGGPEJJ@?$CFd?6?$AA@", i32 0, i32 0), i32 %16)
;--- It does not seem like this branch can be removed
  br label %next

;--- i = i + 1
next:
  %18 = load i32, i32* %1, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, i32* %1, align 4
  br label %loop

;--- exit main
finished:
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 6.0.1 (tags/RELEASE_601/final)"}
