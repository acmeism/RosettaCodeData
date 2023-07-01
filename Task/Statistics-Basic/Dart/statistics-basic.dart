/* Import math library to get:
 *     	1) Square root function 	        : Math.sqrt(x)
 *	2) Power function 		: Math.pow(base, exponent)
 *	3) Random number generator 	: Math.Random()
 */		
import 'dart:math' as Math show sqrt, pow, Random;

// Returns average/mean of a list of numbers
num mean(List<num> l)  => l.reduce((num value,num element)=>value+element)/l.length;

// Returns standard deviation of a list of numbers
num stdev(List<num> l) => Math.sqrt((1/l.length)*l.map((num x)=>x*x).reduce((num value,num element) => value+element) - Math.pow(mean(l),2));

/* CODE TO PRINT THE HISTOGRAM STARTS HERE
 *
 * 	Histogram has ten fields, one for every tenth between 0 and 1
 * 	To do this, we save the histogram as a global variable
 * 	that will hold the number of occurences of each tenth in the sample
 */
List<num> histogram = new List.filled(10,0);

/*
 * METHOD TO CREATE A RANDOM SAMPLE OF n NUMBERS (Returns a list)
 *
 * 	While creating each value, this method also increments the
 * 	appropriate index of the histogram
 */
List<num> randomsample(num n){
  List<num> l = new List<num>(n);
  histogram = new List.filled(10,0);
  num random = new Math.Random();
  for (int i = 0; i < n; i++){
    l[i] = random.nextDouble();
    histogram[conv(l[i])] += 1;
  }
  return l;
}

/*
 * METHOD TO RETURN A STRING OF n ASTERIXES (yay ASCII art)
 */
String stars(num n){
  String s = '';
  for (int i = 0; i < n; i++){
    s = s + '*';
  }
  return s;
}

/*
 * METHOD TO DRAW THE HISTOGRAM
 * 1) Get to total for all the values in the histogram
 * 2) For every field in the histogram:
 * 		a) Compute the frequency for every field in the histogram
 * 		b) Print the frequency as asterixes
 */
void drawhistogram(){
  int total = histogram.reduce((num element,num value)=>element+value);
  double freq;
  for (int i = 0; i < 10; i++){
    freq = histogram[i]/total;
    print('${i/10} - ${(i+1)/10} : ' + stars(conv(30*freq)));
  }
}

/* HELPER METHOD:
 * 	converts values between 0-1 to integers between 0-9 inclusive
 * 	useful to figure out which random value generated
 *	corresponds to which field in the histogram
 */
int conv(num i) => (10*i).floor();


/* MAIN FUNCTION
 *
 * Create 5 histograms and print the mean and standard deviation for each:
 * 	1) Sample Size = 100
 *	2) Sample Size = 1000
 *	3) Sample Size = 10000
 *	4) Sample Size = 100000
 *	5) Sample Size = 1000000
 *
 */
void main(){
  List<num> l;
  num m;
  num s;
  List<int> sampleSizes = [100,1000,10000,100000,1000000];
  for (int samplesize in sampleSizes){
    print('---------------  Sample size $samplesize   ----------------');
    l = randomsample(samplesize);
    m = mean(l);
    s = stdev(l);
    drawhistogram();
    print('');
    print('mean: ${m.toStringAsPrecision(8)}   standard deviation: ${s.toStringAsPrecision(8)}');
    print('');
  }
}
