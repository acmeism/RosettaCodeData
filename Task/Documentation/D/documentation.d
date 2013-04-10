/**
 * This is a documentation comment for somefunc and somefunc2.
 * Does not need to be preceded by '*' in every line - this is done purely for code style
 * $(DDOC_COMMENT comment inside a documentation comment (results in a HTML comment not displayed by the browser))
 * Header:
 *     content (does not need to be tabbed out; this is done for clarity of the comments and has no effect on the
 *     resulting documentation)
 * Params:
 *     arg1 = Something (listed as "int <i>arg1</i> Something")
 *     arg2 = Something else
 * Returns:
 *     Nothing
 * TODO:
 *     Nothing at all
 * BUGS:
 *     None found
 */
void somefunc(int arg1, int arg2)
{
}
// this groups this function with the above (both have the same doc and are listed together)
/// ditto
void somefunc2(int arg1, int arg2)
{
}
/++ Another documentation comment +/
void main()
{
}
