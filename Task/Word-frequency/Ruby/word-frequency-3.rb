wf = File.read("135-0.txt", :encoding => "UTF-8")
  .downcase
  .scan(/\w+/)
  .each_with_object(Hash.new(0)) { |word, hash| hash[word] += 1 }
  .sort_by { |k, v| v }
  .reverse
  .take(10)
  .each_with_index { |w, i|
  printf "[%2d] %10s : %d\n",
         i += 1,
         w[0],
         w[1]
}
