from difflib import ndiff

def levenshtein(str1, str2):
    result = ""
    pos, removed = 0, 0
    for x in ndiff(str1, str2):
        if pos<len(str1) and str1[pos] == x[2]:
          pos += 1
          result += x[2]
          if x[0] == "-":
              removed += 1
          continue
        else:
          if removed > 0:
            removed -=1
          else:
            result += "-"
    print(result)

levenshtein("place","palace")
levenshtein("rosettacode","raisethysword")
