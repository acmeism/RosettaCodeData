#!/bin/sed -f

s|<|\&lt;|g
s|>|\&gt;|g
s|^| <tr>\n  <td>|
s|,|</td>\n  <td>|
s|$|</td>\n </tr>|
1s|^|<table>\n|
$s|$|\n</table>|
