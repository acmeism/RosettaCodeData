Rebol [
    title: "Rosetta code: Get system command output"
    file:  %Get_system_command_output.r3
    url:   https://rosettacode.org/wiki/Bitmap/Get_system_command_output
]

system-command: function[
    "Execute a system command and get its output"
    command [string!] "The shell command string to execute"
][
    out: copy ""  ;; Buffer to capture stdout
    err: copy ""  ;; Buffer to capture stderr

    ;; Run the command in a shell, routing stdout -> out, stderr -> err
    ;; Returns an integer exit code (0 = success)
    res: call/shell/output/error :command :out :err

    ;; Return all three results as a block for multi-value destructuring
    reduce [res out err]
]

;; Pick the correct directory-listing command for the current OS
command: either system/platform = 'Windows ["dir"]["ls -la"]

;; Execute the command and unpack the returned [exit-code stdout stderr] block
set [res out err] system-command :command

;; Print stdout on success (exit code 0), otherwise print stderr
print either res == 0 [out][err]
