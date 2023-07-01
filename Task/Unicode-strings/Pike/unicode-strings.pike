#charset utf8
void main()
{
    string nånsense = "\u03bb \0344 \n";
    string hello = "你好";
    string 水果 = "pineapple";
    string 真相 = sprintf("%s, %s goes really well on pizza\n", hello, 水果);
    write( string_to_utf8(真相) );
    write( string_to_utf8(nånsense) );
}
