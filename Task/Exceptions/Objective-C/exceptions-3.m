@try {
  [self foo];
}
@catch (MyException *exc) {
  //Catch only your specified type of exception
}
@catch (NSException *exc) {
  //Catch any NSException or subclass
  NSLog(@"caught exception named %@, with reason: %@", [exc name], [exc reason]);
}
@catch (id exc) {
  //Catch any kind of object
}
@finally {
  //This code is always executed after exiting the try block
}
