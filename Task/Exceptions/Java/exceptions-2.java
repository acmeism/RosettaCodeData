public void fooChecked() throws MyException {
   throw new MyException();
}

public void fooUnchecked() {
   throw new MyRuntimeException();
}
