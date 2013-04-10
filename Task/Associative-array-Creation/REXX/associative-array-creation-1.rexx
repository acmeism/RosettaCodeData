/* Rexx */

key0 = '0'
key1 = 'key0'

stem. = '.'          /* Initialize the associative array 'stem' to '.' */
stem.key1 = 'value0' /* Set a specific key/value pair */

Say '<stem key="'key0'" value="'stem.key0'" />' /* Display a value for a key that wasn't set */
Say '<stem key="'key1'" value="'stem.key1'" />' /* Display a value for a key that was set */
