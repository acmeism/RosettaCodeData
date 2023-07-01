#ifndef CALLBACK_H
#define CALLBACK_H

/*
 * By declaring the function in a separate file, we allow
 * it to be used by other source files.
 *
 * It also stops ICC from complaining.
 *
 * If you don't want to use it outside of callback.c, this
 * file can be removed, provided the static keyword is prepended
 * to the definition.
 */
void map(int* array, int len, void(*callback)(int,int));

#endif
