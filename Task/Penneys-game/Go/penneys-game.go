package main
import "fmt"
import "math/rand"
func main(){
var a1,a2,a3,y,match,j,k int
var inp string
y=1
for y==1{
fmt.Println("Enter your sequence:")
fmt.Scanln(&inp)
var Ai [3] int
var user [3] int
for j=0;j<3;j++{
if(inp[j]==104){
user[j]=1
}else{
user[j]=0
}
}
for k=0;k<3;k++{
Ai[k]=rand.Intn(2)
}
for user[0]==Ai[0]&&user[1]==Ai[1]&&user[2]==Ai[2]{
for k=0;k<3;k++{
Ai[k]=rand.Intn(2)
}
}
fmt.Println("You gave the sequence:")
printht(user)
fmt.Println()
fmt.Println("The computer generated sequence is:")
printht(Ai)
fmt.Println()
a1=rand.Intn(2)
a2=rand.Intn(2)
a3=rand.Intn(2)
fmt.Print("The generated sequence is:")
printh(a1)
printh(a2)
printh(a3)
match=0
for match==0{
if(matches(user,a1,a2,a3)==1){
fmt.Println()
fmt.Println("You have won!!!")
match=1
}else if(matches(Ai,a1,a2,a3)==1){
fmt.Println()
fmt.Println("You lost!! Computer wins")
match=1
}else{
a1=a2
a2=a3
a3=rand.Intn(2)
printh(a3)
}
}
fmt.Println("Do you want to continue(0/1):")
fmt.Scanln(&y)
}
}
func printht(a [3] int) int{
var i int
for i=0;i<3;i++{
if(a[i]==1){
fmt.Print("h")
}else{
fmt.Print("t")
}
}
return 1
}
func printh(a int) int{
if(a==1){
fmt.Print("h")
}else{
fmt.Print("t")
}
return 1
}
func matches(a [3] int,p int,q int,r int) int{
if(a[0]==p&&a[1]==q&&a[2]==r){
return 1
}else{
return 0
}
}
