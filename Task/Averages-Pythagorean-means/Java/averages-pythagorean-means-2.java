   public static double arithmAverage(double array[]){
       if (array == null ||array.length == 0) {
         return 0.0;
      }
      else {
         return DoubleStream.of(array).average().getAsDouble();
      }
   }

    public static double geomAverage(double array[]){
      if (array == null ||array.length == 0) {
         return 0.0;
      }
      else {
         double aver = DoubleStream.of(array).reduce(1, (x, y) -> x * y);
         return   Math.pow(aver, 1.0 / array.length);
      }
   }

     public static double harmAverage(double array[]){
         if (array == null ||array.length == 0) {
         return 0.0;
      }
      else {
         double aver = DoubleStream.of(array)
                  // remove null values
                  .filter(n -> n > 0.0)
                  // generate 1/n array
                  .map( n-> 1.0/n)
                  // accumulating
                  .reduce(0, (x, y) -> x + y);
                  // just this reduce is not working- need to do in 2 steps
                 // .reduce(0, (x, y) -> 1.0/x + 1.0/y);
         return   array.length / aver ;
      }
   }
