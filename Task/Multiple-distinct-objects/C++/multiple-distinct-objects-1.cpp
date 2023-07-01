// this assumes T is a default-constructible type (all built-in types are)
T* p = new T[n]; // if T is POD, the objects are uninitialized, otherwise they are default-initialized

//If default initialisation is not what you want, or if T is a POD type which will be uninitialized
for(size_t i = 0; i != n; ++i)
   p[i] = make_a_T(); //or some other expression of type T

// when you don't need the objects any more, get rid of them
delete[] p;
