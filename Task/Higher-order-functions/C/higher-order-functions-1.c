void myFuncSimple( void (*funcParameter)(void) )
{
    /* ... */

    (*funcParameter)();  /* Call the passed function. */
    funcParameter();     /* Same as above with slight different syntax. */

    /* ... */
}
