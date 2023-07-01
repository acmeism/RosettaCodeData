?- reading_JSON_term.
JSON as Prolog dict: _G5217{widget:_G5207{debug:on,image:_G5123{alignment:center,hOffset:250,name:sun1,src:Images/Sun.png,vOffset:250},text:_G5189{alignment:center,data:Click Here,hOffset:250,name:text1,onMouseUp:sun1.opacity = (sun1.opacity / 100) * 90;,size:36,style:bold,vOffset:100},window:_G5077{height:500,name:main_window,title:Sample Konfabulator Widget,width:500}}}

Access field "widget.text.data": Click Here

Alter field "widget": _G5217{widget:Altered}

true.

?- searalize_a_JSON_term.
{
  "book": {
    "author": {"first_name":"Ramond", "last_name":"Smullyan"},
    "publisher":"Alfred A. Knopf",
    "title":"To Mock a Mocking Bird",
    "year":1985
  }
}
true.
