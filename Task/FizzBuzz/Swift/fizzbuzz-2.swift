for i in 1...100{
    var s:String?
    if i%3==0{s="Fizz"}
    if i%5==0{s=(s ?? "")+"Buzz"}
    print(s ?? i)
}
