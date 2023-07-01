/*
 * Function to test if a number is a perfect number
 * A number is a perfect number if it is equal to the sum of all its divisors
 * Input: Positive integer n
 * Output: true if n is a perfect number, false otherwise
 */
bool isPerfect(int n){
    //Generate a list of integers in the range 1 to n-1 : [1, 2, ..., n-1]
    List<int> range = new List<int>.generate(n-1, (int i) => i+1);

    //Create a list that filters the divisors of n from range
    List<int> divisors = new List.from(range.where((i) => n%i == 0));

    //Sum the all the divisors
    int sumOfDivisors = 0;
    for (int i = 0; i < divisors.length; i++){
        sumOfDivisors = sumOfDivisors + divisors[i];
    }

    // A number is a perfect number if it is equal to the sum of its divisors
    // We return the test if n is equal to sumOfDivisors
    return n == sumOfDivisors;
}
