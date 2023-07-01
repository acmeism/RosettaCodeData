#!/usr/bin/env bash
SITE=https://www.rosettacode.org
API=$SITE/mw/api.php
PAGES=$SITE/mw/index.php
query="$API?action=query"
query+=$(printf '&%s' \
          list=categorymembers \
          cmtitle=Category:Programming_Tasks \
          cmlimit=500)
total=0
while read title; do
  t=${title// /_}
  tasks=$(curl -s "$PAGES?title=$t&action=raw" \
          | grep -c '{{header|')
  printf '%s: %d examples.\n' "$title" "$tasks"
  let total+=tasks
done < <(curl -s "$query&format=json" \
         | jq -r '.query.categorymembers[].title')

printf '\nTotal: %d examples.\n' "$total"
