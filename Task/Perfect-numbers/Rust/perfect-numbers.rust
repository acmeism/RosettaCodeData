fn main ( ) {
	fn factor_sum(n: i32) -> i32 {
	    let mut v = Vec::new(); //create new empty array
	    for  x in 1..n-1 {      //test vaules 1 to n-1
	    	if n%x == 0 {   //if current x is a factor of n
	    		v.push(x);      //add x to the array
	    	}
	    }
    let mut sum = v.iter().sum(); //iterate over array and sum it up
    return sum;
    }

    fn perfect_nums(n: i32) {
    	for x in 2..n {       //test numbers from 1-n
    		if factor_sum(x) == x {//call factor_sum on each value of x, if return value is = x
    			println!("{} is a perfect number.", x); //print value of x
    		}
    	}
    }
    perfect_nums(10000);
}
