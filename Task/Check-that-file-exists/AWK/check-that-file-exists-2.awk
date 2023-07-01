#
# Check if file or directory exists, even 0-length file.
#   Return 0 if not exist, 1 if exist
#
function exists(file    ,line, msg)
{
        if ( (getline line < file) == -1 )
        {
                # "Permission denied" is for MS-Windows
                msg = (ERRNO ~ /Permission denied/ || ERRNO ~ /a directory/) ? 1 : 0
                close(file)
                return msg
        }
        else {
                close(file)
                return 1
        }
}
BEGIN {
    exists("input.txt")
    exists("\\input.txt")
    exists("docs")
    exists("\\docs")
    exit(0)
}
