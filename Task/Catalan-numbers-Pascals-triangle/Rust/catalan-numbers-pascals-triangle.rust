fn main()
{let n=15usize;
 let mut t= [0; 17];
 t[1]=1;
 let mut j:usize;
 for i in 1..n+1
 {
	j=i;
	loop{
	    if j==1{
		      break;
		}
		t[j]=t[j] + t[j-1];
		j=j-1;
	}
	t[i+1]= t[i];
	j=i+1;
	loop{
		if j==1{
		break;
		}
		t[j]=t[j] + t[j-1];
		j=j-1;
	}
	print!("{} ", t[i+1]-t[i]);
 }
}
