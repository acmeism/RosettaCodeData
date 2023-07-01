/*
 author: snugsfbay
 date: March 3, 2016
 description: Create a list of x numbers in the Fibonacci sequence.
     - user may specify the length of the list
     - enforces a minimum of 2 numbers in the sequence because any fewer is not a sequence
     - enforces a maximum of 47 because further values are too large for integer data type
     - Fibonacci sequence always starts with 0 and 1 by definition
*/
public class FibNumbers{

final static Integer MIN = 2; //minimum length of sequence
final static Integer MAX = 47; //maximum length of sequence

/*
  description: method to create a list of numbers in the Fibonacci sequence
  param: user specified integer representing length of sequence should be 2-47, inclusive.
      - Sequence starts with 0 and 1 by definition so the minimum length could be as low as 2.
      - For 48th number in sequence or greater, code would require a Long data type rather than an Integer.
  return: list of integers in sequence.
*/
public static List<Integer> makeSeq(Integer len){

  List<Integer> fib = new List<Integer>{0,1}; // initialize list with first two values
  Integer i;

  if(len<MIN || len==null || len>MAX) {
      if (len>MAX){
          len=MAX; //set length to maximum if user entered too high a value
      }else{
          len=MIN; //set length to minimum if user entered too low a value or none
      }
  } //This could be refactored using teneray operator, but we want code coverage to be reflected for each condition

  //start with initial list size to find previous two values in the sequence, continue incrementing until list reaches user defined length
  for(i=fib.size(); i<len; i++){
    fib.add(fib[i-1]+fib[i-2]); //create new number based on previous numbers and add that to the list
  }

  return fib;
  }

}
