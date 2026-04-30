$test = "$([char]9)Français."

"Original string              : `"$test`""
"Control characters stripped  : `"$($test | Remove-Character -Control)`""
"Extended characters stripped : `"$($test | Remove-Character -Extended)`""
"Control & extended stripped  : `"$($test | Remove-Character)`""
