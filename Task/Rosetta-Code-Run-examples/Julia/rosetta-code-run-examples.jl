using HTTP
using Gumbo

const LANGUAGE_SUPPORT = Dict(
	"go" => ["go", `go run rc_temp_go.go`, "rc_temp_go.go"],
	"julia" => ["jl", `julia rc_temp_julia.jl`, "rc_temp_julia.jl"],
	"perl" => ["pl", `perl rc_temp_perl.pl`, "rc_temp_perl.pl"],
	"python" => ["py", `python3 rc_temp_python.py`, "rc_temp_python.py"],
)
const BASE_URL = "https://rosettacode.org/wiki/"

""" Get user input from stdin for yes/no questions. """
function inputyn(prompt::AbstractString)
	while true
		print(prompt)
		answer = strip(readline())
		if !isempty(answer) && (lowercase(answer)[begin] == 'y' || lowercase(answer)[begin] == 'n')
			return lowercase(answer)[begin] == 'y'
		end
		println("Please enter 'y' or 'n'.")
	end
end

""" Interactively fetch and run supported Rosetta Code tasks on rosettacode.org.
This function prompts the user to enter the name of a task, fetches the task page,
and then allows the user to select a programming language to view and run the example's code.
Limitations:
	Restricted to programs of a type listed in LANGUAGE_SUPPORT above.
    The task language used for the example program must be properly installed.
    The task must have a runnable example in the specified language.
	Library modules for some programs may need to be installed separately.
"""
function runexamples()
	while true
		print("Enter the exact name of the task to be checked: ")
		task = strip(readline())
		task = replace(task, " " => "_")
		url = "$BASE_URL$task?action=edit"
		resp = HTTP.get(url)
		if resp.status == 200
			body = String(resp.body)
			lang = ""
			while true
				print("Enter the language (Go/Julia/Perl/Python), blank to exit: ")
				lang = lowercase(strip(readline()))
				isempty(lang) && return
				if lang in keys(LANGUAGE_SUPPORT)
					break
				end
				println("Sorry, that language is not supported.")
			end
			regex = Regex(
				"\n=={{header.$lang}}==.+?syntaxhighlight\\s+lang=\"$lang\"[^>]*>(.*?)(?:[<]|&lt;)/syntaxhighlight",
				"is",
			)
			matches = match(regex, body)
			if !isnothing(matches)
				source = replace(
					HTMLText(matches.captures[begin]).text,
					"&amp;" => "&",
					"&lt;" => "<",
					"&gt;" => ">",
					"&quot;" => "\"",
					"&apos;" => "'",
				)
				println("\nThis is the source code for the first (or only) runnable program:\n")
				println(source)
				if inputyn("\nDo you want to run it? y/n : ")
					file_name = LANGUAGE_SUPPORT[lang][end]
					write(file_name, source)
					run(LANGUAGE_SUPPORT[lang][begin+1])
					rm(file_name)
				end
			else
				println("No runnable task entry for that language was detected.")
			end
		else
			println("Error fetching task: $task. HTTP status: $(resp.status)")
		end
		!inputyn("\nCheck another task? y/n : ") && break
	end
end

runexamples()
