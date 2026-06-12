@msg_test = internal constant [33 x i8] c"Test: The meaning of life is %d\0A\00"

declare i32 @printf(i8* noalias nocapture, ...)

declare i32 @meaning_of_life()

define i32 @main(i32 %argc, i8** %argv) {
	%meaning = call i32 @meaning_of_life()

	call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([33 x i8]* @msg_test, i32 0, i32 0), i32 %meaning)

	ret i32 0
}
