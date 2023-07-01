*** Welcome to IELM ***  Type (describe-mode) for help.
ELISP> (defun my-join (str1 str2 sep)
	 (concat str1 sep sep str2))
my-join
ELISP> (my-join "Rosetta" "Code" ":")
"Rosetta::Code"
ELISP>
