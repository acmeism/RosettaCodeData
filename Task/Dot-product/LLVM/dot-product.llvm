; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

;--- The declarations for the external C functions
declare i32 @printf(i8*, ...)

$"INTEGER_FORMAT" = comdat any

@main.a = private unnamed_addr constant [3 x i32] [i32 1, i32 3, i32 -5], align 4
@main.b = private unnamed_addr constant [3 x i32] [i32 4, i32 -2, i32 -1], align 4
@"INTEGER_FORMAT" = linkonce_odr unnamed_addr constant [4 x i8] c"%d\0A\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @dot_product(i32*, i32*, i64) #0 {
  %4 = alloca i64, align 8                              ;-- allocate copy of n
  %5 = alloca i32*, align 8                             ;-- allocate copy of b
  %6 = alloca i32*, align 8                             ;-- allocate copy of a
  %7 = alloca i32, align 4                              ;-- allocate sum
  %8 = alloca i64, align 8                              ;-- allocate i
  store i64 %2, i64* %4, align 8                        ;-- store a copy of n
  store i32* %1, i32** %5, align 8                      ;-- store a copy of b
  store i32* %0, i32** %6, align 8                      ;-- store a copy of a
  store i32 0, i32* %7, align 4                         ;-- store 0 in sum
  store i64 0, i64* %8, align 8                         ;-- store 0 in i
  br label %loop

loop:
  %9 = load i64, i64* %8, align 8                       ;-- load i
  %10 = load i64, i64* %4, align 8                      ;-- load n
  %11 = icmp ult i64 %9, %10                            ;-- i < n
  br i1 %11, label %loop_body, label %exit

loop_body:
  %12 = load i32*, i32** %6, align 8                    ;-- load a
  %13 = load i64, i64* %8, align 8                      ;-- load i
  %14 = getelementptr inbounds i32, i32* %12, i64 %13   ;-- calculate a[i]
  %15 = load i32, i32* %14, align 4                     ;-- load a[i]

  %16 = load i32*, i32** %5, align 8                    ;-- load b
  %17 = load i64, i64* %8, align 8                      ;-- load i
  %18 = getelementptr inbounds i32, i32* %16, i64 %17   ;-- calculate b[i]
  %19 = load i32, i32* %18, align 4                     ;-- load b[i]

  %20 = mul nsw i32 %15, %19                            ;-- temp = a[i] * b[i]

  %21 = load i32, i32* %7, align 4                      ;-- load sum
  %22 = add nsw i32 %21, %20                            ;-- add sum and temp
  store i32 %22, i32* %7, align 4                       ;-- store sum

  %23 = load i64, i64* %8, align 8                      ;-- load i
  %24 = add i64 %23, 1                                  ;-- increment i
  store i64 %24, i64* %8, align 8                       ;-- store i
  br label %loop

exit:
  %25 = load i32, i32* %7, align 4                      ;-- load sum
  ret i32 %25                                           ;-- return sum
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca [3 x i32], align 4                        ;-- allocate a
  %2 = alloca [3 x i32], align 4                        ;-- allocate b

  %3 = bitcast [3 x i32]* %1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %3, i8* bitcast ([3 x i32]* @main.a to i8*), i64 12, i32 4, i1 false)

  %4 = bitcast [3 x i32]* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %4, i8* bitcast ([3 x i32]* @main.b to i8*), i64 12, i32 4, i1 false)

  %5 = getelementptr inbounds [3 x i32], [3 x i32]* %2, i32 0, i32 0
  %6 = getelementptr inbounds [3 x i32], [3 x i32]* %1, i32 0, i32 0
  %7 = call i32 @dot_product(i32* %6, i32* %5, i64 3)

  %8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"INTEGER_FORMAT", i32 0, i32 0), i32 %7)
  ret i32 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
