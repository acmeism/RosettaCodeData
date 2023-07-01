#include <string.h>

/* ... */

/* assign an empty string */
const char *str = "";

/* to test a null string */
if (str) { ... }

/* to test if string is empty */
if (str[0] == '\0') { ... }

/* or equivalently use strlen function
   strlen will seg fault on NULL pointer, so check first */
if ( (str == NULL) || (strlen(str) == 0)) { ... }

/* or compare to a known empty string, same thing. "== 0" means strings are equal */
if (strcmp(str, "") == 0) { ... }
