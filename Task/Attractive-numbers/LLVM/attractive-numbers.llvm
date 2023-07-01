; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

$"ATTRACTIVE_STR" = comdat any
$"FORMAT_NUMBER" = comdat any
$"NEWLINE_STR" = comdat any

@"ATTRACTIVE_STR" = linkonce_odr unnamed_addr constant [52 x i8] c"The attractive numbers up to and including %d are:\0A\00", comdat, align 1
@"FORMAT_NUMBER" = linkonce_odr unnamed_addr constant [4 x i8] c"%4d\00", comdat, align 1
@"NEWLINE_STR" = linkonce_odr unnamed_addr constant [2 x i8] c"\0A\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

; Function Attrs: noinline nounwind optnone uwtable
define zeroext i1 @is_prime(i32) #0 {
  %2 = alloca i1, align 1               ;-- allocate return value
  %3 = alloca i32, align 4              ;-- allocate n
  %4 = alloca i32, align 4              ;-- allocate d
  store i32 %0, i32* %3, align 4        ;-- store local copy of n
  store i32 5, i32* %4, align 4         ;-- store 5 in d
  %5 = load i32, i32* %3, align 4       ;-- load n
  %6 = icmp slt i32 %5, 2               ;-- n < 2
  br i1 %6, label %nlt2, label %niseven

nlt2:
  store i1 false, i1* %2, align 1       ;-- store false in return value
  br label %exit

niseven:
  %7 = load i32, i32* %3, align 4       ;-- load n
  %8 = srem i32 %7, 2                   ;-- n % 2
  %9 = icmp ne i32 %8, 0                ;-- (n % 2) != 0
  br i1 %9, label %odd, label %even

even:
  %10 = load i32, i32* %3, align 4      ;-- load n
  %11 = icmp eq i32 %10, 2              ;-- n == 2
  store i1 %11, i1* %2, align 1         ;-- store (n == 2) in return value
  br label %exit

odd:
  %12 = load i32, i32* %3, align 4      ;-- load n
  %13 = srem i32 %12, 3                 ;-- n % 3
  %14 = icmp ne i32 %13, 0              ;-- (n % 3) != 0
  br i1 %14, label %loop, label %div3

div3:
  %15 = load i32, i32* %3, align 4      ;-- load n
  %16 = icmp eq i32 %15, 3              ;-- n == 3
  store i1 %16, i1* %2, align 1         ;-- store (n == 3) in return value
  br label %exit

loop:
  %17 = load i32, i32* %4, align 4      ;-- load d
  %18 = load i32, i32* %4, align 4      ;-- load d
  %19 = mul nsw i32 %17, %18            ;-- d * d
  %20 = load i32, i32* %3, align 4      ;-- load n
  %21 = icmp sle i32 %19, %20           ;-- (d * d) <= n
  br i1 %21, label %first, label %prime

first:
  %22 = load i32, i32* %3, align 4      ;-- load n
  %23 = load i32, i32* %4, align 4      ;-- load d
  %24 = srem i32 %22, %23               ;-- n % d
  %25 = icmp ne i32 %24, 0              ;-- (n % d) != 0
  br i1 %25, label %second, label %notprime

second:
  %26 = load i32, i32* %4, align 4      ;-- load d
  %27 = add nsw i32 %26, 2              ;-- increment d by 2
  store i32 %27, i32* %4, align 4       ;-- store d
  %28 = load i32, i32* %3, align 4      ;-- load n
  %29 = load i32, i32* %4, align 4      ;-- load d
  %30 = srem i32 %28, %29               ;-- n % d
  %31 = icmp ne i32 %30, 0              ;-- (n % d) != 0
  br i1 %31, label %loop_end, label %notprime

loop_end:
  %32 = load i32, i32* %4, align 4      ;-- load d
  %33 = add nsw i32 %32, 4              ;-- increment d by 4
  store i32 %33, i32* %4, align 4       ;-- store d
  br label %loop

notprime:
  store i1 false, i1* %2, align 1       ;-- store false in return value
  br label %exit

prime:
  store i1 true, i1* %2, align 1        ;-- store true in return value
  br label %exit

exit:
  %34 = load i1, i1* %2, align 1        ;-- load return value
  ret i1 %34
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @count_prime_factors(i32) #0 {
  %2 = alloca i32, align 4                      ;-- allocate return value
  %3 = alloca i32, align 4                      ;-- allocate n
  %4 = alloca i32, align 4                      ;-- allocate count
  %5 = alloca i32, align 4                      ;-- allocate f
  store i32 %0, i32* %3, align 4                ;-- store local copy of n
  store i32 0, i32* %4, align 4                 ;-- store zero in count
  store i32 2, i32* %5, align 4                 ;-- store 2 in f
  %6 = load i32, i32* %3, align 4               ;-- load n
  %7 = icmp eq i32 %6, 1                        ;-- n == 1
  br i1 %7, label %eq1, label %ne1

eq1:
  store i32 0, i32* %2, align 4                 ;-- store zero in return value
  br label %exit

ne1:
  %8 = load i32, i32* %3, align 4               ;-- load n
  %9 = call zeroext i1 @is_prime(i32 %8)        ;-- is n prime?
  br i1 %9, label %prime, label %loop

prime:
  store i32 1, i32* %2, align 4                 ;-- store a in return value
  br label %exit

loop:
  %10 = load i32, i32* %3, align 4              ;-- load n
  %11 = load i32, i32* %5, align 4              ;-- load f
  %12 = srem i32 %10, %11                       ;-- n % f
  %13 = icmp ne i32 %12, 0                      ;-- (n % f) != 0
  br i1 %13, label %br2, label %br1

br1:
  %14 = load i32, i32* %4, align 4              ;-- load count
  %15 = add nsw i32 %14, 1                      ;-- increment count
  store i32 %15, i32* %4, align 4               ;-- store count
  %16 = load i32, i32* %5, align 4              ;-- load f
  %17 = load i32, i32* %3, align 4              ;-- load n
  %18 = sdiv i32 %17, %16                       ;-- n / f
  store i32 %18, i32* %3, align 4               ;-- n = n / f
  %19 = load i32, i32* %3, align 4              ;-- load n
  %20 = icmp eq i32 %19, 1                      ;-- n == 1
  br i1 %20, label %br1_1, label %br1_2

br1_1:
  %21 = load i32, i32* %4, align 4              ;-- load count
  store i32 %21, i32* %2, align 4               ;-- store the count in the return value
  br label %exit

br1_2:
  %22 = load i32, i32* %3, align 4              ;-- load n
  %23 = call zeroext i1 @is_prime(i32 %22)      ;-- is n prime?
  br i1 %23, label %br1_3, label %loop

br1_3:
  %24 = load i32, i32* %3, align 4              ;-- load n
  store i32 %24, i32* %5, align 4               ;-- f = n
  br label %loop

br2:
  %25 = load i32, i32* %5, align 4              ;-- load f
  %26 = icmp sge i32 %25, 3                     ;-- f >= 3
  br i1 %26, label %br2_1, label %br3

br2_1:
  %27 = load i32, i32* %5, align 4              ;-- load f
  %28 = add nsw i32 %27, 2                      ;-- increment f by 2
  store i32 %28, i32* %5, align 4               ;-- store f
  br label %loop

br3:
  store i32 3, i32* %5, align 4                 ;-- store 3 in f
  br label %loop

exit:
  %29 = load i32, i32* %2, align 4              ;-- load return value
  ret i32 %29
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4                      ;-- allocate i
  %2 = alloca i32, align 4                      ;-- allocate n
  %3 = alloca i32, align 4                      ;-- count
  store i32 0, i32* %3, align 4                 ;-- store zero in count
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([52 x i8], [52 x i8]* @"ATTRACTIVE_STR", i32 0, i32 0), i32 120)
  store i32 1, i32* %1, align 4                 ;-- store 1 in i
  br label %loop

loop:
  %5 = load i32, i32* %1, align 4               ;-- load i
  %6 = icmp sle i32 %5, 120                     ;-- i <= 120
  br i1 %6, label %loop_body, label %exit

loop_body:
  %7 = load i32, i32* %1, align 4               ;-- load i
  %8 = call i32 @count_prime_factors(i32 %7)    ;-- count factors of i
  store i32 %8, i32* %2, align 4                ;-- store factors in n
  %9 = call zeroext i1 @is_prime(i32 %8)        ;-- is n prime?
  br i1 %9, label %prime_branch, label %loop_inc

prime_branch:
  %10 = load i32, i32* %1, align 4              ;-- load i
  %11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"FORMAT_NUMBER", i32 0, i32 0), i32 %10)
  %12 = load i32, i32* %3, align 4              ;-- load count
  %13 = add nsw i32 %12, 1                      ;-- increment count
  store i32 %13, i32* %3, align 4               ;-- store count
  %14 = srem i32 %13, 20                        ;-- count % 20
  %15 = icmp ne i32 %14, 0                      ;-- (count % 20) != 0
  br i1 %15, label %loop_inc, label %row_end

row_end:
  %16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @"NEWLINE_STR", i32 0, i32 0))
  br label %loop_inc

loop_inc:
  %17 = load i32, i32* %1, align 4              ;-- load i
  %18 = add nsw i32 %17, 1                      ;-- increment i
  store i32 %18, i32* %1, align 4               ;-- store i
  br label %loop

exit:
  %19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @"NEWLINE_STR", i32 0, i32 0))
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
