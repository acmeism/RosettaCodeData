; This is not strictly LLVM, as it uses the C library function "printf".
; LLVM does not provide a way to print values, so the alternative would be
; to just load the string into memory, and that would be boring.

; Additional comments have been inserted, as well as changes made from the output produced by clang such as putting more meaningful labels for the jumps

$"main.printf" = comdat any

@main.str = private unnamed_addr constant [12 x i8] c"Hello world\00", align 1
@"main.printf" = linkonce_odr unnamed_addr constant [4 x i8] c"%s\0A\00", comdat, align 1

define void @reverse(i64, i8*) {
  %3 = alloca i8*, align 8          ; allocate str (local)
  %4 = alloca i64, align 8          ; allocate len (local)
  %5 = alloca i64, align 8          ; allocate i
  %6 = alloca i64, align 8          ; allocate j
  %7 = alloca i8, align 1           ; allocate t
  store i8* %1, i8** %3, align 8    ; set str (local) to the parameter str
  store i64 %0, i64* %4, align 8    ; set len (local) to the paremeter len
  store i64 0, i64* %5, align 8     ; i = 0
  %8 = load i64, i64* %4, align 8   ; load len
  %9 = sub i64 %8, 1                ; decrement len
  store i64 %9, i64* %6, align 8    ; j =
  br label %loop

loop:
  %10 = load i64, i64* %5, align 8  ; load i
  %11 = load i64, i64* %6, align 8  ; load j
  %12 = icmp ult i64 %10, %11       ; i < j
  br i1 %12, label %loop_body, label %exit

loop_body:
  %13 = load i8*, i8** %3, align 8                  ; load str
  %14 = load i64, i64* %5, align 8                  ; load i
  %15 = getelementptr inbounds i8, i8* %13, i64 %14 ; address of str[i]
  %16 = load i8, i8* %15, align 1                   ; load str[i]
  store i8 %16, i8* %7, align 1                     ; t = str[i]
  %17 = load i64, i64* %6, align 8                  ; load j
  %18 = getelementptr inbounds i8, i8* %13, i64 %17 ; address of str[j]
  %19 = load i8, i8* %18, align 1                   ; load str[j]
  %20 = getelementptr inbounds i8, i8* %13, i64 %14 ; address of str[i]
  store i8 %19, i8* %20, align 1                    ; str[i] = str[j]
  %21 = load i8, i8* %7, align 1                    ; load t
  %22 = getelementptr inbounds i8, i8* %13, i64 %17 ; address of str[j]
  store i8 %21, i8* %22, align 1                    ; str[j] = t

;-- loop increment
  %23 = load i64, i64* %5, align 8  ; load i
  %24 = add i64 %23, 1              ; increment i
  store i64 %24, i64* %5, align 8   ; store i
  %25 = load i64, i64* %6, align 8  ; load j
  %26 = add i64 %25, -1             ; decrement j
  store i64 %26, i64* %6, align 8   ; store j
  br label %loop

exit:
  ret void
}

define i32 @main() {
;-- char str[]
  %1 = alloca [12 x i8], align 1
;-- memcpy(str, "Hello world")
  %2 = bitcast [12 x i8]* %1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @main.str, i32 0, i32 0), i64 12, i32 1, i1 false)
;-- printf("%s\n", str)
  %3 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 0
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"main.printf", i32 0, i32 0), i8* %3)
;-- %7 = strlen(str)
  %5 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 0
  %6 = call i64 @strlen(i8* %5)
;-- reverse(%6, str)
  call void @reverse(i64 %6, i8* %5)
;-- printf("%s\n", str)
  %7 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 0
  %8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @"main.printf", i32 0, i32 0), i8* %7)
;-- end of main
  ret i32 0
}

;--- The declaration for the external C printf function.
declare i32 @printf(i8*, ...)

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1)

declare i64 @strlen(i8*)
