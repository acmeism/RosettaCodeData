def sort_by_characters:
  explode | map([.]|implode) | sort | add;
