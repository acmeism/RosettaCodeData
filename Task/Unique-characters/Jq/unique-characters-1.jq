# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# Input: an array of strings
# Output: an array of the characters that appear just once
def in_one_just_once:
  bow( .[] | explode[] | [.] | implode) | with_entries(select(.value==1)) | keys;
