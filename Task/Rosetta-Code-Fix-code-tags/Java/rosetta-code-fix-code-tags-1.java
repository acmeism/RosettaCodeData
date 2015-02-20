import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

public class FixCodeTags
{
	public static void main(String[] args)
	{
		String sourcefile=args[0];
		String convertedfile=args[1];
		convert(sourcefile,convertedfile);
	}
		static String[] languages = {"abap", "actionscript", "actionscript3",
			"ada", "apache", "applescript", "apt_sources", "asm", "asp",
			"autoit", "avisynth", "bar", "bash", "basic4gl", "bf",
			"blitzbasic", "bnf", "boo", "c", "caddcl", "cadlisp", "cfdg",
			"cfm", "cil", "c_mac", "cobol", "cpp", "cpp-qt", "csharp", "css",
			"d", "delphi", "diff", "_div", "dos", "dot", "eiffel", "email",
			"foo", "fortran", "freebasic", "genero", "gettext", "glsl", "gml",
			"gnuplot", "go", "groovy", "haskell", "hq9plus", "html4strict",
			"idl", "ini", "inno", "intercal", "io", "java", "java5",
			"javascript", "kixtart", "klonec", "klonecpp", "latex", "lisp",
			"lolcode", "lotusformulas", "lotusscript", "lscript", "lua",
			"m68k", "make", "matlab", "mirc", "modula3", "mpasm", "mxml",
			"mysql", "nsis", "objc", "ocaml", "ocaml-brief", "oobas",
			"oracle11", "oracle8", "pascal", "per", "perl", "php", "php-brief",
			"pic16", "pixelbender", "plsql", "povray", "powershell",
			"progress", "prolog", "providex", "python", "qbasic", "rails",
			"reg", "robots", "ruby", "sas", "scala", "scheme", "scilab",
			"sdlbasic", "smalltalk", "smarty", "sql", "tcl", "teraterm",
			"text", "thinbasic", "tsql", "typoscript", "vb", "vbnet",
			"verilog", "vhdl", "vim", "visualfoxpro", "visualprolog",
			"whitespace", "winbatch", "xml", "xorg_conf", "xpp", "z80"};
	static void convert(String sourcefile,String convertedfile)
	{
		try
		{
			BufferedReader br=new BufferedReader(new FileReader(sourcefile));
			//String buffer to store contents of the file
			StringBuffer sb=new StringBuffer("");
			String line;
			while((line=br.readLine())!=null)
			{
				for(int i=0;i<languages.length;i++)
				{
					String lang=languages[i];
					line=line.replaceAll("<"+lang+">", "<lang "+lang+">");
					line=line.replaceAll("</"+lang+">", "</"+lang+">");
					line=line.replaceAll("<code "+lang+">", "<lang "+lang+">");
					line=line.replaceAll("</code>", "</"+"lang>");
				}
				sb.append(line);
			}
			br.close();
			
			FileWriter fw=new FileWriter(new File(convertedfile));
			//Write entire string buffer into the file
			fw.write(sb.toString());
			fw.close();
		}
		catch (Exception e)
		{
			System.out.println("Something went horribly wrong: "+e.getMessage());
		}
	}
}
