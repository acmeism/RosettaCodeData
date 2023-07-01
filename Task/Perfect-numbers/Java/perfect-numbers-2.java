import java.math.BigInteger;

public static boolean perf(BigInteger n){
	BigInteger sum= BigInteger.ZERO;
	for(BigInteger i= BigInteger.ONE;
	i.compareTo(n) < 0;i=i.add(BigInteger.ONE)){
		if(n.mod(i).equals(BigInteger.ZERO)){
			sum= sum.add(i);
		}
	}
	return sum.equals(n);
}
