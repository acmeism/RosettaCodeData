Java has an interactive REPL (Read-Evaluate-Print-Loop) console, jshell, that is included with the JDK.
The REPL is started by invoking: $JAVA_HOME/bin/jshell
Here is a sample session to accomplish the task.

 | Welcome to JShell -- Version 20
 | For an introduction type: /help

 jshell> String concat(String a, String b, String c) { return a + c + c + b; }
 |  created method concat(String, String, String)

 jshell> concat("Rosetta", "Code", ":")
 $2 ==> "Rosetta::Code"

 jshell>
