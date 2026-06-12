var B

{ // block starts here
    var A = 2

    class C {
        static method1() {
            System.print(A)   // Error at 'A': Variable is used but not defined.
        }
    }

    B = C
} // end of block

B.method()
