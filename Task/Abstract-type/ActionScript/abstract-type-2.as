package {
    import flash.utils.getQualifiedClassName;

    public class AbstractClass {

        private static const FULLY_QUALIFIED_NAME:String = "AbstractClass";

        // For classes in a package, the fully qualified name should be in the form "package.name::class_name"
        // Note that a double colon and not a dot is used before the class name. This is the format returned
        // by the getQualifiedClassName() function.

        public function AbstractClass() {
            if ( getQualifiedClassName(this) == FULLY_QUALIFIED_NAME )
                throw new Error("Class " + FULLY_QUALIFIED_NAME + " is abstract.");
        }

        public function abstractMethod(a:int, b:int):void {
            throw new Error("abstractMethod is not implemented.");
        }

    }
}
