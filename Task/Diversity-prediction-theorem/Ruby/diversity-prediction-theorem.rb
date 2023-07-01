def mean(a) = a.sum(0.0) / a.size
def mean_square_diff(a, predictions) = mean(predictions.map { |x| square(x - a)**2 })

def diversity_theorem(truth, predictions)
    average = mean(predictions)
    puts "truth: #{truth}, predictions #{predictions}",
         "average-error: #{mean_square_diff(truth, predictions)}",
         "crowd-error: #{(truth - average)**2}",
         "diversity: #{mean_square_diff(average, predictions)}",""
end

diversity_theorem(49.0, [48.0, 47.0, 51.0])
diversity_theorem(49.0, [48.0, 47.0, 51.0, 42.0])
