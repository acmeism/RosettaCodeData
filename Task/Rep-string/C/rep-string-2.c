// strstr : Returns a pointer to the first occurrence of str2 in str1, or a null pointer if str2 is not part of str1.
// size_t is an unsigned integer typ
// lokks for the shortest substring
int repstr(char *str)
{
    if (!str) return 0; // if empty input

    size_t sl = 1;
    size_t sl_max = strlen(str) ;

    while (sl < sl_max) {
        if (strstr(str, str + sl) == str) // How it works ???? It checks the whole string str
        	return sl;
        ++sl;
    }

    return 0;
}
