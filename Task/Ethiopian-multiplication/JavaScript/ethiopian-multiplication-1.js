var eth = {
	
	halve : function ( n ){  return Math.floor(n/2);  },
	double: function ( n ){  return 2*n;              },
	isEven: function ( n ){  return n%2 === 0);       },
	
	mult: function ( a , b ){
		var sum = 0, a = [a], b = [b];
		
		while ( a[0] !== 1 ){
			a.unshift( eth.halve( a[0] ) );
			b.unshift( eth.double( b[0] ) );
		}
		
		for( var i = a.length - 1; i > 0 ; i -= 1 ){
			
			if( !eth.isEven( a[i] ) ){
				sum += b[i];
			}
		}		
		return sum + b[0];
	}
}
// eth.mult(17,34) returns 578
