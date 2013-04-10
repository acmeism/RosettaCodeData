use Inline C => q{
    char *copy;
    char * c_dup(char *orig) {
        return copy = strdup(orig);
    }
    void c_free() {
        free(copy);
    }
};
print c_dup('Hello'), "\n";
c_free();
