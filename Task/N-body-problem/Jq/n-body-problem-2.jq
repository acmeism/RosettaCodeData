# Read the parameters assuming invocation of jq includes the -n option
# Emit a JSON object {masses, positions, velocities, accelerations, lines, ...}
def NBodyProblem:
  [inputs] as $lines
  | [$lines[0] | splits("  *") | tonumber] as $gbt
  | $gbt[1] as $bodies
  | {gc: $gbt[0],
     $bodies,
     timeSteps: $gbt[2],
     masses: null,
     positions:  null,
     velocities: null,
     accelerations: null,
     $lines}
  | reduce range(0;$bodies) as $i (.;
      .masses[$i]       = ($lines[$i * 3 + 1] | tonumber)
      | .positions[$i]  = ($lines[$i * 3 + 2] | toVector3D)
      | .velocities[$i] = ($lines[$i * 3 + 3] | toVector3D) ) ;

# {bodies, positions, velocities}
def resolveCollisions:
  reduce range(0; .bodies) as $i (.;
    reduce range($i + 1; .bodies) as $j (.;
      if .positions[$i] == .positions[$j]
      then .velocities[$i] as $temp
      | .velocities[$i] = .velocities[$j]
      | .velocities[$j] = $temp
      else .
      end) );

# input {bodies, positions, accelarations}
def computeAccelerations:
  .bodies as $bodies
  | reduce range(0; $bodies) as $i (.;
      .accelerations[$i] = Origin
      | reduce range(0; $bodies) as $j (.;
          if $i != $j
          then (.gc * .masses[$j] /
                pow( Vector3D_minus(.positions[$i]; .positions[$j]) | norm; 3) ) as $temp
          | .accelerations[$i] = (
              [ .accelerations[$i],
                (Vector3D_minus(.positions[$j]; .positions[$i]) | Vector3D_mult($temp)) ]
              | Vector3D_add )
          else .
          end ));

def computeVelocities:
  reduce range(0; .bodies) as $i (.;
    .velocities[$i] = ([.velocities[$i], .accelerations[$i] ] | Vector3D_add) );

def computePositions:
  reduce range(0; .bodies) as $i (.;
    .positions[$i] = ([.positions[$i], .velocities[$i], (.accelerations[$i] | Vector3D_mult(0.5) )]
                      | Vector3D_add) ) ;

def simulate:
  computeAccelerations
  | computePositions
  | computeVelocities
  | resolveCollisions;

def printResults:
  def p:
    tostring
    | if startswith("-")
      then "-" + (.[1:] | align_decimal(6))
      else " " + align_decimal(6)
      end
    | lpad(8);

  range(0; .bodies) as $i
  | "Body \($i + 1) : \(.positions[$i].x |p)  \(.positions[$i].y  |p)  \(.positions[$i].z |p) | "
                  + "\(.velocities[$i].x |p)  \(.velocities[$i].y |p)  \(.velocities[$i].z|p)" ;

def prelude:
  "Contents of input file",
  .lines[],
  "",
  "Body   :      x         y          z     |     vx        vy         vz";

def task:
  NBodyProblem
  | (prelude,
     foreach range (1; 1 + .timeSteps) as $i (.;
      simulate;
      "\nCycle \($i)", printResults) ) ;

task
