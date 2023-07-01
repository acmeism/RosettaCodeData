# Test this example file from command line with:
#
#    awk -f file.awk /dev/null
#
# Code by Jari Aalto <jari.aalto A T cante net>
# Licensed and released under GPL-2+, see http://spdx.org/licenses

function alen(array,   dummy, len) {
    for (dummy in array)
        len++;

    return len;
}

function sort(array,   haschanged, len, tmp, i)
{
    len = alen(array)
    haschanged = 1

    while ( haschanged == 1 )
    {
        haschanged = 0

        for (i = 1; i <= len - 1; i++)
        {
            if (array[i] > array[i+1])
            {
                tmp = array[i]
                array[i] = array[i + 1]
                array[i + 1] = tmp
                haschanged = 1
            }
        }
    }
}

# An Example. Sorts array to order: b, c, z
{
    array[1] = "c"
    array[2] = "z"
    array[3] = "b"
    sort(array)
    print array[1] " " array[2] " " array[3]
    exit
}
