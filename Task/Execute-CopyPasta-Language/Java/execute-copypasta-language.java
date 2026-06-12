import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;

public class Copypasta
{
	// a function to handle fatal errors
	public static void fatal_error(String errtext)
	{
		StackTraceElement[] stack = Thread.currentThread().getStackTrace();
		StackTraceElement main = stack[stack.length - 1];
		String mainClass = main.getClassName();
		System.out.println("%" + errtext);
		System.out.println("usage: " + mainClass + " [filename.cp]");
		System.exit(1);
	}
	public static void main(String[] args)
	{
		// get a filename from the command line and read the file in
		String fname = null;
		String source = null;
		try
		{
			fname = args[0];
			source = new String(Files.readAllBytes(new File(fname).toPath()));
		}
		catch(Exception e)
		{
			fatal_error("error while trying to read from specified file");
		}

		// convert the source to lines of code
		ArrayList<String> lines = new ArrayList<String>(Arrays.asList(source.split("\n")));
		
		// a variable to represent the 'clipboard'
		String clipboard = "";
		
		// loop over the lines that were read
		int loc = 0;
		while(loc < lines.size())
		{
			// check which command is on this line
			String command = lines.get(loc).trim();

			try
			{
				if(command.equals("Copy"))
					clipboard += lines.get(loc + 1);
				else if(command.equals("CopyFile"))
				{
					if(lines.get(loc + 1).equals("TheF*ckingCode"))
						clipboard += source;
					else
					{
						String filetext = new String(Files.readAllBytes(new File(lines.get(loc + 1)).toPath()));
						clipboard += filetext;
					}
				}
				else if(command.equals("Duplicate"))
				{
					String origClipboard = clipboard;

					int amount = Integer.parseInt(lines.get(loc + 1)) - 1;
					for(int i = 0; i < amount; i++)
						clipboard += origClipboard;
				}
				else if(command.equals("Pasta!"))
				{
					System.out.println(clipboard);
					System.exit(0);
				}
				else
					fatal_error("unknown command '" + command + "' encountered on line " + new Integer(loc + 1).toString());
			}
			catch(Exception e)
			{
				fatal_error("error while executing command '" + command + "' on line " + new Integer(loc + 1).toString());
			}

			// increment past the command and the next line
			loc += 2;
		}
	}
}
