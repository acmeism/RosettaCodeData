func reverseString(s:String)->String{
    var temp = [Character]()
    for i in s.characters{
        temp.append(i)
    }
    var j=s.characters.count-1
    for i in s.characters{
        temp[j]=i
        j-=1
    }
    return String(temp)
}

func reverseWord(s:String)->String{
    var temp = [Character]()
    var result:String=""
    for i in s.characters{
        if i==" "{
            result += "\(reverseString(s:String(temp))) "
            temp=[Character]()
        }
        else {
            temp.append(i)
        }
        if i==s[s.index(before: s.endIndex)]{
            result += (reverseString(s:String(temp)))
        }
    }
    return result
}

func flipString(s:String)->String{
    return reverseWord(s:reverseString(s:s))
}
print(str)
print(reverseString(s:str))
print(reverseWord(s:str))
print(flipString(s:str))
