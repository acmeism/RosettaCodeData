$define LIB "libstrdup-wrapper.so"

# the unicon wrapper to access the C function
procedure strdup (str)
  static f
  initial {
    f := loadfunc (LIB, "strdup_wrapper") // pick out the wrapped function from the shared library
  }
  return f(str) // call the wrapped function
end

procedure strcat (str1, str2)
  static f
  initial {
    f := loadfunc (LIB, "strcat_wrapper")
  }
  return f(str1, str2)
end

procedure main ()
  write (strdup ("abc"))
  write (strcat ("abc", "def"))
end
