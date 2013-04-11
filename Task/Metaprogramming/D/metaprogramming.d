template GenStruct(string name, string fieldName) {
    enum GenStruct = "struct " ~ name ~ "{ int " ~ fieldName ~ "; }";
}

mixin(GenStruct!("Foo", "bar"));

// Is equivalent to:
// struct Foo { int bar; }

void main() {
    Foo f;
    f.bar = 10;
}
