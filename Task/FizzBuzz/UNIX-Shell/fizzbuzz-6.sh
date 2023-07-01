for i in {1..100};do ((($i%15==0))&& echo FizzBuzz)||((($i%5==0))&& echo Buzz;)||((($i%3==0))&& echo Fizz;)||echo $i;done
