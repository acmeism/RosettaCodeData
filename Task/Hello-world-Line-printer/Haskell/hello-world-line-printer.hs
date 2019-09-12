import System.Process (ProcessHandle, runCommand)

main :: IO ProcessHandle
main = runCommand "echo \"Hello World!\" | lpr"
