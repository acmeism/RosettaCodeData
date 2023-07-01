String string = "as⃝df̅";
StringBuilder reversed = new StringBuilder();
for (int index = string.length() - 1; index >= 0; index--)
    reversed.append(string.charAt(index));
reversed; // fd⃝sa
