s="hello"
echo "$s literal"
s1="$s literal"    # This method only works with a space between the strings
echo $s1

# To concatenate without the space we need squiggly brackets:
genus='straw'
fruit=${genus}berry  # This outputs the word strawberry
echo $fruit
