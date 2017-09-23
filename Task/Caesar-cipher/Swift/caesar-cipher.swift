var arr:[Character]=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

func res(st:String,ar:[Character],x:Int,ro:String)->String{

    var str2:[Character]=[]

    for i in st.characters
    {

        for j in 0...25
        {


            if i==ar[j]
            {

                switch ro
                {
                    case "right":

                    if(j+x<=25)
                    {

                        str2.append(ar[j+x])
                        break

                    }
                    else
                    {

                        str2.append(ar[j+x-26])
                        break
                    }

                    case "left":

                     if(j-x>=0)
                    {

                        str2.append(ar[j-x])
                        break
                    }
                    else
                    {

                        str2.append(ar[j-x+26])
                        break
                    }
                   default:
                   print("incorrect input for rotation direction")
                }


            }
        }
    }

    return String(str2)
}

var mssg:String="hi"
var x1:Int=5
var rot:String="right"
var rotstr:String=res(st:mssg,ar:arr,x:x1,ro:rot)
print(rotstr)
