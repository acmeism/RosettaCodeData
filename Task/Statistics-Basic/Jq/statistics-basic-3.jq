for n in 100 1000 1000000 100000000; do
    echo "Basic statistics for $n PRNs in [0,1]"
    prng $n 10 | jq -nrR -f basicStats.jq
    echo
done
