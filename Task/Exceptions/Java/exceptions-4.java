public void foo() throws UnsupportedDataTypeException{
    try{
        throwsNumberFormatException();
        //the following methods throw exceptions which extend IOException
        throwsUnsupportedDataTypeException();
        throwsFileNotFoundException();
    }catch(FileNotFoundException | NumberFormatException ex){
        //deal with these two Exceptions without duplicating code
    }catch(IOException e){
        //deal with the UnsupportedDataTypeException as well as any other unchecked IOExceptions
        throw e;
    }
}
