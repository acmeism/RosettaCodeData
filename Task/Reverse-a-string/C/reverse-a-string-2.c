#include <glib.h>
gchar *srev (const gchar *s) {
    if (g_utf8_validate(s,-1,NULL)) {
        return g_utf8_strreverse (s,-1);
}   }
// main
int main (void) {
    const gchar *t="asdf";
    const gchar *u="as⃝df̅";
    printf ("%s\n",srev(t));
    printf ("%s\n",srev(u));
    return 0;
}
