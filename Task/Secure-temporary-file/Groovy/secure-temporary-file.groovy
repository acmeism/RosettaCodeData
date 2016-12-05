def file = File.createTempFile( "xxx", ".txt" )

// There is no requirement in the instructions to delete the file.
//file.deleteOnExit()

println file
