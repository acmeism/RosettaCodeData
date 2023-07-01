:: quadratic-equation2 ( a b c -- x1 x2 )
 a c * sqrt b / :> q
 1 4 q sq * - sqrt 0.5 * 0.5 + :> f
 b neg a / f * c neg b / f / ;
