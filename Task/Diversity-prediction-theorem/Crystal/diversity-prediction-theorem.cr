module Enumerable
  def average
    sum / size
  end
end

def get_values (true_value, crowd_estimates)
  avg_individual_error = crowd_estimates.map {|e| (e - true_value)**2 }.average
  collective_error = (crowd_estimates.average - true_value)**2
  crowd_avg = crowd_estimates.average
  prediction_diversity = crowd_estimates.map {|e| (e - crowd_avg)**2 }.average

  { avg_individual_error, collective_error, prediction_diversity }
end

puts "Value  Crowd estimates   Average error   Crowd error   Prediction diversity"
puts "---------------------------------------------------------------------------"

[{49, [48, 47, 51]}, {49, [48, 47, 51, 42]}].each do |true_value, crowd_estimates|
  printf "  %2d   %-20s %9.5f     %9.5f              %9.5f\n", true_value, crowd_estimates,
         *get_values(true_value, crowd_estimates)
end
