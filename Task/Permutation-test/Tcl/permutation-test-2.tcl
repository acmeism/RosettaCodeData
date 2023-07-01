set treatmentGroup {0.85 0.88 0.75 0.66 0.25 0.29 0.83 0.39 0.97}
set controlGroup   {0.68 0.41 0.10 0.49 0.16 0.65 0.32 0.92 0.28 0.98}
lassign [permutationTest $treatmentGroup $controlGroup] over under
puts [format "under=%.2f%%, over=%.2f%%" [expr {$under*100}] [expr {$over*100}]]
