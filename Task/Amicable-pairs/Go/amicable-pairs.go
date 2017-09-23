package main
import "fmt"
import "math"
func main() {
var i int
var a [200001]int
a[0]=0
for i=1;i<=20000;i++{
a[i]=pfac_sum(i)
}
fmt.Println("The amicable pairs are:")
for i=1;i<=20000;i++{
if (i==a[a[i]])&&(i<a[i]){
  fmt.Printf("%d , %d\n",i,a[i])
}
}
}
func pfac_sum(i int) int {
	var p,sum=1,0
	
	for p=1;p<=i/2;p++{
	x := float64(i)
	y := float64(p)
	  if math.Mod(x,y)==0{
	   sum= sum+p
	  }
	}
	return sum
}
