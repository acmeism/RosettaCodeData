; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

;--- The declarations for the external C functions
declare i32 @printf(i8*, ...)

$"FORMAT_STR" = comdat any
@"FORMAT_STR" = linkonce_odr unnamed_addr constant [4 x i8] c"%u\0A\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4          ;-- allocate i
  store i32 0, i32* %1, align 4     ;-- store i as 0
  br label %loop

loop:
  %2 = load i32, i32* %1, align 4   ;-- load i
  %3 = add i32 %2, 1                ;-- increment i
  store i32 %3, i32* %1, align 4    ;-- store i
  %4 = icmp ne i32 %3, 0            ;-- i != 0
  br i1 %4, label %loop_body, label %exit

loop_body:
  %5 = load i32, i32* %1, align 4   ;-- load i
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"FORMAT_STR", i32 0, i32 0), i32 %5)
  br label %loop

exit:
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
