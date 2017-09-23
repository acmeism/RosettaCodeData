func pascal(n:Int)->[Int]{
    if n==1{
        let a=[1]
        print(a)
        return a
    }
    else{
        var a=pascal(n:n-1)
        var temp=a
        for i in 0..<a.count{
            if i+1==a.count{
                temp.append(1)
                break
            }
            temp[i+1] = a[i]+a[i+1]
        }
        a=temp
        print(a)
        return a
    }
}
let waste = pascal(n:10)
