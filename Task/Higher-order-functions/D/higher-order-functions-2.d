import std.stdio;

// Test the function argument.
string test(U)(string scopes, U func) {
    string typeStr = typeid(typeof(func)).toString();

    string isFunc = (typeStr[$ - 1] == '*') ? "function" : "delegate";
    writefln("Hi, %-13s : scope: %-8s (%s) : %s",
             func(), scopes, isFunc, typeStr );
    return scopes;
}

// Normal module level function.
string aFunction() { return "Function"; }

// Implicit-Function-Template-Instantiation (IFTI) Function.
T tmpFunc(T)() { return "IFTI.function"; }

// Member in a template.
template tmpGroup(T) {
    T t0(){ return "Tmp.member.0"; }
    T t1(){ return "Tmp.member.1"; }
    T t2(){ return "Tmp.member.2"; }
}

// Used for implementing member function at class & struct.
template Impl() {
    static string aStatic() { return "Static Method";  }
    string aMethod() { return "Method"; }
}

class C { mixin Impl!(); }
struct S { mixin Impl!(); }

void main() {
    // Nested function.
    string aNested() {
        return "Nested";
    }

  // Bind to a variable.
  auto variableF = function string() { return "variable.F"; };
  auto variableD = delegate string() { return "variable.D"; };

  C c = new C;
  S s;

      "Global".test(&aFunction);
      "Nested".test(&aNested);
       "Class".test(&C.aStatic)
              .test(&c.aMethod);
      "Struct".test(&S.aStatic)
              .test(&s.aMethod);
    "Template".test(&tmpFunc!(string))
              .test(&tmpGroup!(string).t2);
     "Binding".test(variableF)
              .test(variableD);
    // Literal function/delegate.
     "Literal".test(function string() { return "literal.F"; })
              .test(delegate string() { return "literal.D"; });
}
