; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

$"ASSERTION" = comdat any
$"OUTPUT" = comdat any

@"ASSERTION" = linkonce_odr unnamed_addr constant [48 x i8] c"arithmetic-geometric mean undefined when x*y<0\0A\00", comdat, align 1
@"OUTPUT" = linkonce_odr unnamed_addr constant [42 x i8] c"The arithmetic-geometric mean is %0.19lf\0A\00", comdat, align 1

;--- The declarations for the external C functions
declare i32 @printf(i8*, ...)
declare void @exit(i32) #1
declare double @sqrt(double) #1

declare double @llvm.fabs.f64(double) #2

;----------------------------------------------------------------
;-- arithmetic geometric mean
define double @agm(double, double) #0 {
    %3 = alloca double, align 8                     ; allocate local g
    %4 = alloca double, align 8                     ; allocate local a
    %5 = alloca double, align 8                     ; allocate iota
    %6 = alloca double, align 8                     ; allocate a1
    %7 = alloca double, align 8                     ; allocate g1
    store double %1, double* %3, align 8            ; store param g in local g
    store double %0, double* %4, align 8            ; store param a in local a
    store double 1.000000e-15, double* %5, align 8  ; store 1.0e-15 in iota (1.0e-16 was causing the program to hang)

    %8 = load double, double* %4, align 8           ; load a
    %9 = load double, double* %3, align 8           ; load g
    %10 = fmul double %8, %9                        ; a * g
    %11 = fcmp olt double %10, 0.000000e+00         ; a * g < 0.0
    br i1 %11, label %enforce, label %loop

enforce:
    %12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([48 x i8], [48 x i8]* @"ASSERTION", i32 0, i32 0))
    call void @exit(i32 1) #6
    unreachable

loop:
    %13 = load double, double* %4, align 8          ; load a
    %14 = load double, double* %3, align 8          ; load g
    %15 = fsub double %13, %14                      ; a - g
    %16 = call double @llvm.fabs.f64(double %15)    ; fabs(a - g)
    %17 = load double, double* %5, align 8          ; load iota
    %18 = fcmp ogt double %16, %17                  ; fabs(a - g) > iota
    br i1 %18, label %loop_body, label %eom

loop_body:
    %19 = load double, double* %4, align 8          ; load a
    %20 = load double, double* %3, align 8          ; load g
    %21 = fadd double %19, %20                      ; a + g
    %22 = fdiv double %21, 2.000000e+00             ; (a + g) / 2.0
    store double %22, double* %6, align 8           ; store %22 in a1

    %23 = load double, double* %4, align 8          ; load a
    %24 = load double, double* %3, align 8          ; load g
    %25 = fmul double %23, %24                      ; a * g
    %26 = call double @sqrt(double %25) #4          ; sqrt(a * g)
    store double %26, double* %7, align 8           ; store %26 in g1

    %27 = load double, double* %6, align 8          ; load a1
    store double %27, double* %4, align 8           ; store a1 in a

    %28 = load double, double* %7, align 8          ; load g1
    store double %28, double* %3, align 8           ; store g1 in g

    br label %loop

eom:
    %29 = load double, double* %4, align 8          ; load a
    ret double %29                                  ; return a
}

;----------------------------------------------------------------
;-- main
define i32 @main() #0 {
    %1 = alloca double, align 8                     ; allocate x
    %2 = alloca double, align 8                     ; allocate y

    store double 1.000000e+00, double* %1, align 8  ; store 1.0 in x

    %3 = call double @sqrt(double 2.000000e+00) #4  ; calculate the square root of two
    %4 = fdiv double 1.000000e+00, %3               ; divide 1.0 by %3
    store double %4, double* %2, align 8            ; store %4 in y

    %5 = load double, double* %2, align 8           ; reload y
    %6 = load double, double* %1, align 8           ; reload x
    %7 = call double @agm(double %6, double %5)     ; agm(x, y)

    %8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @"OUTPUT", i32 0, i32 0), double %7)

    ret i32 0                                       ; finished
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noreturn "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone speculatable }
attributes #4 = { nounwind }
attributes #6 = { noreturn }
