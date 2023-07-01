; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

;--- The declarations for the external C functions
declare i32 @printf(i8*, ...)

$"FORMAT_AND" = comdat any

$"FORMAT_OR" = comdat any

$"FORMAT_NOT" = comdat any

@"FORMAT_AND" = linkonce_odr unnamed_addr constant [15 x i8] c"a and b is %d\0A\00", comdat, align 1
@"FORMAT_OR" = linkonce_odr unnamed_addr constant [14 x i8] c"a or b is %d\0A\00", comdat, align 1
@"FORMAT_NOT" = linkonce_odr unnamed_addr constant [13 x i8] c"not a is %d\0A\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define void @print_logic(i32, i32) #0 {
  %3 = alloca i32, align 4          ;-- allocate b
  %4 = alloca i32, align 4          ;-- allocate a
  store i32 %1, i32* %3, align 4    ;-- copy parameter b
  store i32 %0, i32* %4, align 4    ;-- copy parameter a
  %5 = load i32, i32* %4, align 4   ;-- load a
  %6 = icmp ne i32 %5, 0            ;-- is a true?
  br i1 %6, label %and_true, label %and_false

and_true:
  %7 = load i32, i32* %3, align 4
  %8 = icmp ne i32 %7, 0
  br label %and_false

and_false:
  %9 = phi i1 [ false, %2 ], [ %8, %and_true ]
  %10 = zext i1 %9 to i32
  %11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @"FORMAT_AND", i32 0, i32 0), i32 %10)
  %12 = load i32, i32* %4, align 4  ;-- load a
  %13 = icmp ne i32 %12, 0          ;-- is a true?
  br i1 %13, label %or_true, label %or_false

or_false:
  %14 = load i32, i32* %3, align 4  ;-- load b
  %15 = icmp ne i32 %14, 0          ;-- is b true?
  br label %or_true

or_true:
  %16 = phi i1 [ true, %and_false ], [ %15, %or_false ]
  %17 = zext i1 %16 to i32
  %18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @"FORMAT_OR", i32 0, i32 0), i32 %17)

  %19 = load i32, i32* %4, align 4  ;-- load a
  %20 = icmp ne i32 %19, 0
  %21 = xor i1 %20, true
  %22 = zext i1 %21 to i32
  %23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @"FORMAT_NOT", i32 0, i32 0), i32 %22)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4          ;-- allocate i
  %2 = alloca i32, align 4          ;-- allocate j
  store i32 0, i32* %1, align 4     ;-- store 0 in i
  br label %loop_i

loop_i:
  %3 = load i32, i32* %1, align 4   ;-- load i
  %4 = icmp slt i32 %3, 2           ;-- i < 2
  br i1 %4, label %loop_j_init, label %exit

loop_j_init:
  store i32 0, i32* %2, align 4     ;-- store 0 in j
  br label %loop_j

loop_j:
  %5 = load i32, i32* %2, align 4   ;-- load j
  %6 = icmp slt i32 %5, 2           ;-- j < 2
  br i1 %6, label %loop_body, label %loop_i_inc

loop_body:
  %7 = load i32, i32* %2, align 4   ;-- load j
  %8 = load i32, i32* %1, align 4   ;-- load i
  call void @print_logic(i32 %8, i32 %7)
  %9 = load i32, i32* %2, align 4   ;-- load j
  %10 = add nsw i32 %9, 1           ;-- increment j
  store i32 %10, i32* %2, align 4   ;-- store j
  br label %loop_j

loop_i_inc:
  %11 = load i32, i32* %1, align 4  ;-- load i
  %12 = add nsw i32 %11, 1          ;-- increment i
  store i32 %12, i32* %1, align 4   ;-- store i
  br label %loop_i

exit:
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
