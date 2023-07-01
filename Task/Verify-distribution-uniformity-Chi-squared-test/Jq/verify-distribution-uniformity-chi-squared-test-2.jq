# Input: array of frequencies
def chi2UniformDistance:
  (add / length) as $expected
  |  ss(.[] - $expected) / $expected;

# Input: a number
# Output: an indication of the probability of observing this value or higher
#   assuming the value is drawn from a chi-squared distribution with $dof degrees
#   of freedom
def chi2Probability($dof):
  (1 - Chi2_cdf(.; $dof))
  | if . < 1e-10 then "< 1e-10"
    else .
    end;

# Input: array of frequencies
# Output: result of a two-tailed test based on the chi-squared statistic
# assuming the sample size is large enough
def chiIsUniform($significance):
  (length - 1) as $dof
  | chi2UniformDistance
  | Chi2_cdf(.; $dof) as $cdf
  | if $cdf
    then ($significance/2) as $s
    | $cdf > $s and $cdf < (1-$s)
    else false
    end;

def dsets: [
    [199809, 200665, 199607, 200270, 199649],
    [522573, 244456, 139979,  71531,  21461],
    [19,14,6,18,7,5,1],  # low entropy
    [9,11,9,10,15,11,5], # high entropy
    [20,20,20]           # made-up
];

def task:
  dsets[]
  | "Dataset: \(.)",
    ( chi2UniformDistance as $dist
      | (length - 1) as $dof
      | "DOF: \($dof)  D (Distance): \($dist)",
        "  Estimated probability of observing a value >= D: \($dist|chi2Probability($dof)|round(2))",
        "  Uniform? \( (select(chiIsUniform(0.05)) | "Yes") // "No" )\n" ) ;

task
