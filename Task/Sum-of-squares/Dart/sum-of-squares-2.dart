num sumOfSquares(List<num> l) => l.map((num x)=>x*x)
				  .fold(0, (num p,num n)=> p + n);

void main(){
  print(sumOfSquares([]));
  print(sumOfSquares([1,2,3]));
  print(sumOfSquares([10]));
}
