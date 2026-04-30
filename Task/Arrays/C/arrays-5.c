int numElements = 10;
int *myArray = malloc(sizeof(int) * numElements);  /* array of 10 integers */
if ( myArray != NULL )   /* check to ensure allocation succeeded. */
{
  /* allocation succeeded */
  /* at the end, we need to free the allocated memory */
  free(myArray);
}
                    /* calloc() additionally pre-initializes to all zeros */
short *myShorts = calloc( numElements, sizeof(short)); /* array of 10 */
if (myShorts != NULL)....
