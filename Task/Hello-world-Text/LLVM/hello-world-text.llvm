; const char str[14] = "Hello World!\00"
@.str = private unnamed_addr constant  [14 x i8] c"Hello, world!\00"

; declare extern `puts` method
declare i32 @puts(i8*) nounwind

define i32 @main()
{
  call i32 @puts( i8* getelementptr ([14 x i8]* @str, i32 0,i32 0))
  ret i32 0
}
