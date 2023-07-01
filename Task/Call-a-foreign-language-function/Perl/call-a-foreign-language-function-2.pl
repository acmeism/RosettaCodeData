use Inline C => q{
    void c_hello (char *text) {
        char *copy = strdup(text);
        printf("Hello, %s!\n", copy);
        free(copy);
    }
};
c_hello 'world';
