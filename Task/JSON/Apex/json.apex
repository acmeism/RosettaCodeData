class TestClass{
    String foo {get;set;}
    Integer bar {get;set;}
}

TestClass testObj = new TestClass();
testObj.foo = 'ABC';
testObj.bar = 123;

String serializedString = JSON.serialize(testObj);
TestClass deserializedObject = (TestClass)JSON.deserialize(serializedString, TestClass.class);

//"testObj.foo == deserializedObject.foo" is true
//"testObj.bar == deserializedObject.bar" is true
