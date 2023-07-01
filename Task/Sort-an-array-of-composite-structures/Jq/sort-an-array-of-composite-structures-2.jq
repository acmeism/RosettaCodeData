# To sort the array:
# example | sort_by(.name)

# To abbreviate the results, we will just show the names after sorting:

example | sort_by(.name) | map( .name )
