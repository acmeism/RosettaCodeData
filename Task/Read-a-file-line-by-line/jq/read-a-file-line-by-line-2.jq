$ seq 0 5 | jq -R 'tonumber|sin' | jq -s max
0.9092974268256817
