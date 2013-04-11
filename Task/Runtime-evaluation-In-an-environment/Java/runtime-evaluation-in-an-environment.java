ScriptEngine js = new ScriptEngineManager().getEngineByName("js");
System.out.println(js.eval("function D(x){return x*2;} var x=3; x=D(x);"));
