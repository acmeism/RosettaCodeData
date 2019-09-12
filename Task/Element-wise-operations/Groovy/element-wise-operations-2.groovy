import org.codehaus.groovy.runtime.DefaultGroovyMethods

class NaiveMatrixCategory {
   static NaiveMatrix plus (Number a, NaiveMatrix b) { b + a }
   static NaiveMatrix minus (Number a, NaiveMatrix b) { -b + a }
   static NaiveMatrix multiply (Number a, NaiveMatrix b) { b * a }
   static NaiveMatrix div (Number a, NaiveMatrix b) { a * b.recip() }
   static NaiveMatrix power (Number a, NaiveMatrix b) { b.binaryOp(a) { elt, scalar -> scalar ** elt } }
   static NaiveMatrix mod (Number a, NaiveMatrix b) { b.binaryOp(a) { elt, scalar -> scalar % elt } }

   static <T> T asType (Number a, Class<T> type) {
       type == NaiveMatrix \
           ? [[a]] as NaiveMatrix
           : DefaultGroovyMethods.asType(a, type)
   }
}
