try {
   fooChecked();
}
catch(MyException exc) {
   //Catch only your specified type of exception
}
catch(Exception exc) {
   //Catch any non-system error exception
}
catch(Throwable exc) {
   //Catch everything including system errors (not recommended)
}
finally {
   //This code is always executed after exiting the try block
}
