package main

import (
    "fmt"
)
var
  Primes = []byte{2, 3, 5, 7};
var
  gblCount = 0;
var
  PrimesIdx = []byte{0, 1, 2, 3};

func combrep(n int, lst []byte) [][]byte {
    if n == 0 {
        return [][]byte{nil}
    }
    if len(lst) == 0 {
        return nil
    }
    r := combrep(n, lst[1:])
    for _, x := range combrep(n-1, lst) {
        r = append(r, append(x, lst[0]))
    }
    return r
}

func Count(rep []byte)int {
    var PrimCount  [4]int
    for i := 0; i < len(PrimCount); i++ {
      PrimCount[i] = 0;
      }
    //get the count of every item
    for i := 0; i < len(rep); i++ {
      PrimCount[rep[i]]++
      }
    var numfac int = len(rep)

    var numerator,denominator[]int

    for i := 1; i <= len(rep); i++ {
      numerator = append(numerator,i) // factors 1,2,3,4. n
      denominator = append(denominator,1)
      }
    numfac =  0; //idx  in denominator
    for i := 0; i < len(PrimCount); i++ {
      denfac := 1;
      for j := 0; j < PrimCount[i]; j++ {
        denominator[numfac] = denfac
        denfac++
        numfac++
        }
    }
    //calculate permutations with identical items
    numfac = 1;
    for i := 0; i < len(numerator); i++ {
      numfac = (numfac * numerator[i])/denominator[i]
    }
    return numfac
}

func main() {
  for mySum := 2; mySum <= 103;mySum++ {
    gblCount = 0;
    //check for prime
    for i := 2; i*i <= mySum;i++{
      if mySum%i == 0 {
        gblCount=1;
        break
        }
      }
    if  gblCount != 0 {
      continue
      }

    for n := 1; n <= mySum / 2 ; n++ {
        reps := combrep(n, PrimesIdx)
        for _, rep := range reps {
            sum := byte(0)
            for _, r := range rep {
                sum += Primes[r]
            }
            if sum == byte(mySum) {
               gblCount+=Count(rep);
            }
        }
    }
    fmt.Println("The count of numbers whose digits are all prime and sum to",mySum,"is",gblCount)
  }
}
