do {
  try foo()
} catch MyException.TerribleException { // this can be any pattern
  //Catch a specific case of exception
} catch {
  //Catch any exception
}
