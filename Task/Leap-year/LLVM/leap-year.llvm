; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

$"EMPTY_STR" = comdat any
$"NOT_STR" = comdat any
$"IS_A_LEAP_YEAR" = comdat any

@main.test_case = private unnamed_addr constant [5 x i32] [i32 1900, i32 1994, i32 1996, i32 1997, i32 2000], align 16
@"EMPTY_STR" = linkonce_odr unnamed_addr constant [1 x i8] zeroinitializer, comdat, align 1
@"NOT_STR" = linkonce_odr unnamed_addr constant [5 x i8] c"not \00", comdat, align 1
@"IS_A_LEAP_YEAR" = linkonce_odr unnamed_addr constant [22 x i8] c"%d is %sa leap year.\0A\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

; Function Attrs: noinline nounwind optnone uwtable
define i32 @is_leap_year(i32) #0 {
  %2 = alloca i32, align 4              ;-- allocate a local copy of year
  store i32 %0, i32* %2, align 4        ;-- store a copy of year

  %3 = load i32, i32* %2, align 4       ;-- load the year
  %4 = srem i32 %3, 4                   ;-- year % 4
  %5 = icmp ne i32 %4, 0                ;-- (year % 4) != 0
  br i1 %5, label %c1false, label %c1true

c1true:
  %6 = load i32, i32* %2, align 4       ;-- load the year
  %7 = srem i32 %6, 100                 ;-- year % 100
  %8 = icmp ne i32 %7, 0                ;-- (year % 100) != 0
  br i1 %8, label %c2true, label %c1false

c1false:
  %9 = load i32, i32* %2, align 4       ;-- load the year
  %10 = srem i32 %9, 400                ;-- year % 400
  %11 = icmp ne i32 %10, 0              ;-- (year % 400) != 0
  %12 = xor i1 %11, true
  br label %c2true

c2true:
  %13 = phi i1 [ true, %c1true ], [ %12, %c1false ]
  %14 = zext i1 %13 to i64
  %15 = select i1 %13, i32 1, i32 0
  ret i32 %15
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca [5 x i32], align 16       ;-- allocate test_case
  %2 = alloca i32, align 4              ;-- allocate key
  %3 = alloca i32, align 4              ;-- allocate end
  %4 = alloca i32, align 4              ;-- allocate year
  %5 = bitcast [5 x i32]* %1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %5, i8* bitcast ([5 x i32]* @main.test_case to i8*), i64 20, i32 16, i1 false)
  store i32 0, i32* %2, align 4         ;-- store 0 in key
  store i32 5, i32* %3, align 4         ;-- store 5 in end
  br label %loop

loop:
  %6 = load i32, i32* %2, align 4       ;-- load key
  %7 = load i32, i32* %3, align 4       ;-- load end
  %8 = icmp slt i32 %6, %7              ;-- key < end
  br i1 %8, label %loop_body, label %exit

loop_body:
  %9 = load i32, i32* %2, align 4       ;-- load key
  %10 = sext i32 %9 to i64              ;-- sign extend key
  %11 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i64 0, i64 %10
  %12 = load i32, i32* %11, align 4     ;-- load test_case[key]
  store i32 %12, i32* %4, align 4       ;-- store test_case[key] as year

  %13 = load i32, i32* %4, align 4      ;-- load year
  %14 = call i32 @is_leap_year(i32 %13) ;-- is_leap_year(year)
  %15 = icmp eq i32 %14, 1              ;-- is_leap_year(year) == 1
  %16 = zext i1 %15 to i64              ;-- zero extend
  %17 = select i1 %15, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @"EMPTY_STR", i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @"NOT_STR", i32 0, i32 0)

  %18 = load i32, i32* %4, align 4      ;-- load year
  %19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @"IS_A_LEAP_YEAR", i32 0, i32 0), i32 %18, i8* %17)

  %20 = load i32, i32* %2, align 4      ;-- load key
  %21 = add nsw i32 %20, 1              ;-- increment key
  store i32 %21, i32* %2, align 4       ;-- store key
  br label %loop

exit:
  ret i32 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
