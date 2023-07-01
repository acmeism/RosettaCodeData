String substr = 'ABC';
String str = 'ABCZZZABCYABCABCXXABC';
Integer substrLen = substr.length();
Integer count = 0;
Integer index = str.indexOf(substr);
while (index >= 0) {
    count++;
    str = str.substring(index+substrLen);
    index = str.indexOf(substr);
}
System.debug('Count String : '+count);
