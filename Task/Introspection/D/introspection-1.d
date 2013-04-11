import std.compiler;
  static if (version_major < 2 || version_minor > 7) {
    // this prevents further compilation
    static assert (false, "I can't cope with this compiler version");
  }
