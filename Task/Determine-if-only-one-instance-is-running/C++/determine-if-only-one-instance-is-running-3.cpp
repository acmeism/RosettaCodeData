mutex = CreateMutex( NULL, TRUE, "MyApp" );
if ( GetLastError() == ERROR_ALREADY_EXISTS )
{
     // There's another instance running.  What do you do?
}
