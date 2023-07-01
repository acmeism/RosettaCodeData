import std.stdio, std.conv, std.array;

pure string lookAndSay(string s){
  auto result = appender!string;
  auto i=0, j=i+1;
  while(i<s.length){
    while(j<s.length && s[i]==s[j]) j++;
    result.put( text(j-i) ~ s[i] );
    i = j++;
  }
  return result.data;
}
void main(){
  auto s="1";
  for(auto i=0; i<10; i++)
    (s = s.lookAndSay).writeln;	
}
