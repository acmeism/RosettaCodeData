def find_perfects():Unit=
{
   for (candidate <- 2 until 1<<19)
   {
      var sum= ~Rational(candidate)
      for (factor <- 2 until (Math.sqrt(candidate)+1).toInt)
      {
         if (candidate%factor==0)
            sum+= ~Rational(factor)+ ~Rational(candidate/factor)
      }

      if (sum.denominator==1 && sum.numerator==1)
         printf("Perfect number %d sum is %s\n", candidate, sum)
   }
}
