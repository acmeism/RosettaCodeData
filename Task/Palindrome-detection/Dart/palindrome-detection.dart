bool isPalindrome(String s){
  for(int i = 0; i < s.length/2;i++){
    if(s[i] != s[(s.length-1) -i])
      return false;
  }
  return true;
}
