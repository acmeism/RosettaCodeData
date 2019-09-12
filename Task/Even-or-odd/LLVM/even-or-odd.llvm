; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

;--- The declarations for the external C functions
declare i32 @printf(i8*, ...)

$"EVEN_STR" = comdat any
$"ODD_STR" = comdat any

@"EVEN_STR" = linkonce_odr unnamed_addr constant [12 x i8] c"%d is even\0A\00", comdat, align 1
@"ODD_STR" = linkonce_odr unnamed_addr constant [11 x i8] c"%d is odd\0A\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4          ;-- allocate i
  store i32 0, i32* %1, align 4     ;-- store 0 in i
  br label %loop

loop:
  %2 = load i32, i32* %1, align 4   ;-- load i
  %3 = icmp ult i32 %2, 4           ;-- i < 4
  br i1 %3, label %loop_body, label %exit

loop_body:
  %4 = load i32, i32* %1, align 4   ;-- load i
  %5 = and i32 %4, 1                ;-- i & 1
  %6 = icmp eq i32 %5, 0            ;-- (i & 1) == 0
  br i1 %6, label %even_branch, label %odd_branch

even_branch:
  %7 = load i32, i32* %1, align 4   ;-- load i
  %8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @"EVEN_STR", i32 0, i32 0), i32 %7)
  br label %loop_increment

odd_branch:
  %9 = load i32, i32* %1, align 4   ;-- load i
  %10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @"ODD_STR", i32 0, i32 0), i32 %9)
  br label %loop_increment

loop_increment:
  %11 = load i32, i32* %1, align 4  ;-- load i
  %12 = add i32 %11, 1              ;-- increment i
  store i32 %12, i32* %1, align 4   ;-- store i
  br label %loop

exit:
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
