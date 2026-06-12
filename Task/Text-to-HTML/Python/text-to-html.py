import html
import re

UL_REGEX = re.compile(r"^\*")
OL_REGEX = re.compile(r"^\d\.")

TEXT = """     Sample Text

This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.

* This is a bulleted list with a less than sign (<)

* And this is its second line with a greater than sign (>)

A 'normal' paragraph between the lists.

1. This is a numbered list with an ampersand (&)

2. "Second line" in double quotes

3. 'Third line' in single quotes

That's all folks."""


if __name__ == "__main__":
    title_set = False

    in_ul = False
    in_ol = False

    print("<html>")

    for line in TEXT.splitlines():
        if line.strip() == "":
            continue

        line = html.escape(line.lstrip())

        if UL_REGEX.match(line):
            if not title_set:
                print("\t<head>\n\t\t<title>Untitled</title>\n\t</head>")
                title_set = True

            if in_ol:
                print("\t</ol>")
                in_ol = False

            if not in_ul:
                print("\t<ul>")
                in_ul = True

            formatted_string = re.sub(UL_REGEX, "", line).lstrip()
            print(f"\t\t<li>{formatted_string}</li>")
            continue

        if OL_REGEX.match(line):
            if not title_set:
                print("\t<head>\n\t\t<title>Untitled</title>\n\t</head>")
                title_set = True

            if in_ul:
                print("\t</ul>")
                in_ul = False

            if not in_ol:
                print("\t<ol>")
                in_ol = True

            formatted_string = re.sub(OL_REGEX, "", line).lstrip()
            print(f"\t\t<li>{formatted_string}</li>")
            continue

        if in_ul:
            print("\t</ul>")
            in_ul = False

        elif in_ol:
            print("\t</ol>")
            in_ol = False

        if not title_set:
            print(f"\t<head>\n\t\t<title>{line}</title>\n\t</head>")
            title_set = True
        else:
            print(f"\t<p>{line}</p>")

    print("</html>")
