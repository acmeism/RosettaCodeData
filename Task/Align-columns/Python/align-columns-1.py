from itertools import zip_longest

txt = """Given$a$txt$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."""

parts = [line.rstrip("$").split("$") for line in txt.splitlines()]
widths = [max(len(word) for word in col)
          for col in zip_longest(*parts, fillvalue='')]

for justify in "<_Left ^_Center >_Right".split():
    j, jtext = justify.split('_')
    print(f"{jtext} column-aligned output:\n")
    for line in parts:
        print(' '.join(f"{wrd:{j}{wdth}}" for wdth, wrd in zip(widths, line)))
    print("- " * 52)
