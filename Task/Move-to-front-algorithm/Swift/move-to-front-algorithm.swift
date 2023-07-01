var str="broood"
var number:[Int]=[1,17,15,0,0,5]

//function to encode the string
func encode(st:String)->[Int]
{
	
var array:[Character]=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	
	var num:[Int]=[]
	var temp:Character="a"
	var i1:Int=0
	for i in st.characters
	{
		for j in 0...25
		{
			if i==array[j]
			{
				num.append(j)
				temp=array[j]
				i1=j
				while(i1>0)
				{
					array[i1]=array[i1-1]
					i1=i1-1
		
				}
				array[0]=temp
			}
			
		}
		
		
	}
	
	return num
	
}

func decode(s:[Int])->[Character]
{
	
	var st1:[Character]=[]
	var alph:[Character]=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	var temp1:Character="a"
	var i2:Int=0
	for i in 0...s.character.count-1
	{
		i2=s[i]
		st1.append(alph[i2])
		temp1=alph[i2]
			
				while(i2>0)
				{
					alph[i2]=alph[i2-1]
					i2=i2-1
		
				}
				alph[0]=temp1
		
	}
	return st1					
	
}

var encarr:[Int]=encode(st:str)
var decarr:[Character]=decode(s:number)
print(encarr)
print(decarr)
