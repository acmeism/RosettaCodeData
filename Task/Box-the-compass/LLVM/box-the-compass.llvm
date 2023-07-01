; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

;--- The declarations for the external C functions
declare i32 @printf(i8*, ...)

$"COMPASS_STR" = comdat any
$"OUTPUT_STR" = comdat any

@main.degrees = private unnamed_addr constant [33 x double] [double 0.000000e+00, double 1.687000e+01, double 1.688000e+01, double 3.375000e+01, double 5.062000e+01, double 5.063000e+01, double 6.750000e+01, double 8.437000e+01, double 0x40551851EB851EB8, double 1.012500e+02, double 1.181200e+02, double 1.181300e+02, double 1.350000e+02, double 1.518700e+02, double 1.518800e+02, double 1.687500e+02, double 1.856200e+02, double 1.856300e+02, double 2.025000e+02, double 2.193700e+02, double 2.193800e+02, double 2.362500e+02, double 2.531200e+02, double 2.531300e+02, double 2.700000e+02, double 2.868700e+02, double 2.868800e+02, double 3.037500e+02, double 3.206200e+02, double 3.206300e+02, double 3.375000e+02, double 3.543700e+02, double 3.543800e+02], align 16
@"COMPASS_STR" = linkonce_odr unnamed_addr constant [727 x i8] c"North                 North by east         North-northeast       Northeast by north    Northeast             Northeast by east     East-northeast        East by north         East                  East by south         East-southeast        Southeast by east     Southeast             Southeast by south    South-southeast       South by east         South                 South by west         South-southwest       Southwest by south    Southwest             Southwest by west     West-southwest        West by south         West                  West by north         West-northwest        Northwest by west     Northwest             Northwest by north    North-northwest       North by west         North                 \00", comdat, align 1
@"OUTPUT_STR" = linkonce_odr unnamed_addr constant [19 x i8] c"%2d  %.22s  %6.2f\0A\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4                  ;-- allocate i
  %2 = alloca i32, align 4                  ;-- allocate j
  %3 = alloca [33 x double], align 16       ;-- allocate degrees
  %4 = alloca i8*, align 8                  ;-- allocate names
  %5 = bitcast [33 x double]* %3 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %5, i8* bitcast ([33 x double]* @main.degrees to i8*), i64 264, i32 16, i1 false)
  store i8* getelementptr inbounds ([727 x i8], [727 x i8]* @"COMPASS_STR", i32 0, i32 0), i8** %4, align 8
  store i32 0, i32* %1, align 4             ;-- i = 0
  br label %loop

loop:
  %6 = load i32, i32* %1, align 4           ;-- load i
  %7 = icmp slt i32 %6, 33                  ;-- i < 33
  br i1 %7, label %loop_body, label %exit

loop_body:
  %8 = load i32, i32* %1, align 4           ;-- load i
  %9 = sext i32 %8 to i64                   ;-- sign extend i
  %10 = getelementptr inbounds [33 x double], [33 x double]* %3, i64 0, i64 %9  ;-- calculate index of degrees[i]
  %11 = load double, double* %10, align 8   ;-- load degrees[i]
  %12 = fmul double %11, 3.200000e+01       ;-- degrees[i] * 32
  %13 = fdiv double %12, 3.600000e+02       ;-- degrees[i] * 32 / 360.0
  %14 = fadd double 5.000000e-01, %13       ;-- 0.5 + degrees[i] * 32 / 360.0
  %15 = fptosi double %14 to i32            ;-- convert floating point to integer
  store i32 %15, i32* %2, align 4           ;-- write result to j

  %16 = load i8*, i8** %4, align 8          ;-- load names
  %17 = load i32, i32* %2, align 4          ;-- load j
  %18 = srem i32 %17, 32                    ;-- j % 32
  %19 = mul nsw i32 %18, 22                 ;-- (j % 32) * 22
  %20 = sext i32 %19 to i64                 ;-- sign extend the result
  %21 = getelementptr inbounds i8, i8* %16, i64 %20 ;-- load names at the calculated offset
  %22 = load i32, i32* %2, align 4          ;-- load j
  %23 = srem i32 %22, 32                    ;-- j % 32
  %24 = add nsw i32 %23, 1                  ;-- (j % 32) + 1
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @"OUTPUT_STR", i32 0, i32 0), i32 %24, i8* %21, double %11)

  %26 = load i32, i32* %1, align 4          ;-- load i
  %27 = add nsw i32 %26, 1                  ;-- increment i
  store i32 %27, i32* %1, align 4           ;-- store i
  br label %loop

exit:
  ret i32 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
