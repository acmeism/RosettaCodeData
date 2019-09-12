; ModuleID = 'binary.c'
; source_filename = "binary.c"
; target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
; target triple = "x86_64-pc-windows-msvc19.21.27702"

; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

$"\01??_C@_03OFAPEBGM@?$CFs?6?$AA@" = comdat any

;--- String constant defintions
@"\01??_C@_03OFAPEBGM@?$CFs?6?$AA@" = linkonce_odr unnamed_addr constant [4 x i8] c"%s\0A\00", comdat, align 1

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

;--- The declaration for the external C log10 function.
declare double @log10(double) #1

;--- The declaration for the external C malloc function.
declare noalias i8* @malloc(i64) #2

;--- The declaration for the external C free function.
declare void @free(i8*) #2

;----------------------------------------------------------
;-- Function that allocates a string with a binary representation of a number
define i8* @bin(i32) #0 {
;-- uint32_t x (local copy)
  %2 = alloca i32, align 4
;-- size_t bits
  %3 = alloca i64, align 8
;-- intermediate value
  %4 = alloca i8*, align 8
;-- size_t i
  %5 = alloca i64, align 8
  store i32 %0, i32* %2, align 4
;-- x == 0, start determinig what value to initially store in bits
  %6 = load i32, i32* %2, align 4
  %7 = icmp eq i32 %6, 0
  br i1 %7, label %just_one, label %calculate_logs

just_one:
  br label %assign_bits

calculate_logs:
;-- log10((double) x)/log10(2) + 1
  %8 = load i32, i32* %2, align 4
  %9 = uitofp i32 %8 to double
;-- log10((double) x)
  %10 = call double @log10(double %9) #3
;-- log10(2)
  %11 = call double @log10(double 2.000000e+00) #3
;-- remainder of calculation
  %12 = fdiv double %10, %11
  %13 = fadd double %12, 1.000000e+00
  br label %assign_bits

assign_bits:
;-- bits = (x == 0) ? 1 : log10((double) x)/log10(2) + 1;
;-- phi basically selects what the value to assign should be based on which basic block came before
  %14 = phi double [ 1.000000e+00, %just_one ], [ %13, %calculate_logs ]
  %15 = fptoui double %14 to i64
  store i64 %15, i64* %3, align 8
;-- char *ret = malloc((bits + 1) * sizeof (char));
  %16 = load i64, i64* %3, align 8
  %17 = add i64 %16, 1
  %18 = mul i64 %17, 1
  %19 = call noalias i8* @malloc(i64 %18)
  store i8* %19, i8** %4, align 8
  store i64 0, i64* %5, align 8
  br label %loop

loop:
;-- i < bits;
  %20 = load i64, i64* %5, align 8
  %21 = load i64, i64* %3, align 8
  %22 = icmp ult i64 %20, %21
  br i1 %22, label %loop_body, label %exit

loop_body:
;-- ret[bits - i - 1] = (x & 1) ? '1' : '0';
  %23 = load i32, i32* %2, align 4
  %24 = and i32 %23, 1
  %25 = icmp ne i32 %24, 0
  %26 = zext i1 %25 to i64
  %27 = select i1 %25, i32 49, i32 48
  %28 = trunc i32 %27 to i8
  %29 = load i8*, i8** %4, align 8
  %30 = load i64, i64* %3, align 8
  %31 = load i64, i64* %5, align 8
  %32 = sub i64 %30, %31
  %33 = sub i64 %32, 1
  %34 = getelementptr inbounds i8, i8* %29, i64 %33
  store i8 %28, i8* %34, align 1
;-- x >>= 1;
  %35 = load i32, i32* %2, align 4
  %36 = lshr i32 %35, 1
  store i32 %36, i32* %2, align 4
  br label %loop_increment

loop_increment:
;-- i++;
  %37 = load i64, i64* %5, align 8
  %38 = add i64 %37, 1
  store i64 %38, i64* %5, align 8
  br label %loop

exit:
;-- ret[bits] = '\0';
  %39 = load i8*, i8** %4, align 8
  %40 = load i64, i64* %3, align 8
  %41 = getelementptr inbounds i8, i8* %39, i64 %40
  store i8 0, i8* %41, align 1
;-- return ret;
  %42 = load i8*, i8** %4, align 8
  ret i8* %42
}

;----------------------------------------------------------
;-- Entry point into the program
define i32 @main() #0 {
;-- 32-bit zero for the return
  %1 = alloca i32, align 4
;-- size_t i, for tracking the loop index
  %2 = alloca i64, align 8
;-- char* for the result of the bin call
  %3 = alloca i8*, align 8
;-- initialize
  store i32 0, i32* %1, align 4
  store i64 0, i64* %2, align 8
  br label %loop

loop:
;-- while (i < 20)
  %4 = load i64, i64* %2, align 8
  %5 = icmp ult i64 %4, 20
  br i1 %5, label %loop_body, label %exit

loop_body:
;-- char *binstr = bin(i);
  %6 = load i64, i64* %2, align 8
  %7 = trunc i64 %6 to i32
  %8 = call i8* @bin(i32 %7)
  store i8* %8, i8** %3, align 8
;-- printf("%s\n", binstr);
  %9 = load i8*, i8** %3, align 8
  %10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"\01??_C@_03OFAPEBGM@?$CFs?6?$AA@", i32 0, i32 0), i8* %9)
;-- free(binstr);
  %11 = load i8*, i8** %3, align 8
  call void @free(i8* %11)
  br label %loop_increment

loop_increment:
;-- i++
  %12 = load i64, i64* %2, align 8
  %13 = add i64 %12, 1
  store i64 %13, i64* %2, align 8
  br label %loop

exit:
;-- return 0 (implicit)
  %14 = load i32, i32* %1, align 4
  ret i32 %14
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 6.0.1 (tags/RELEASE_601/final)"}
