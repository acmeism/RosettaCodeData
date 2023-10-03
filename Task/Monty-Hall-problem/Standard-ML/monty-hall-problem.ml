val pidint = Word64.toInt(Posix.Process.pidToWord(Posix.ProcEnv.getpid()));
val rand = Random.rand(LargeInt.toInt(Time.toSeconds(Time.now())), pidint);

fun stick_win 0 wins = wins
  | stick_win trial wins =
  let
    val winner_door = (Random.randNat rand) mod 3;
    val chosen_door = (Random.randNat rand) mod 3;
  in
    if winner_door = chosen_door then
      stick_win (trial-1) (wins+1)
    else
      stick_win (trial-1) wins
  end

val trials = 1000000;
val sticks = stick_win trials 0;
val stick_winrate = 100.0 * Real.fromInt(sticks) / Real.fromInt(trials);
(* if you lost by sticking you would have won by swapping *)
val swap_winrate = 100.0 - stick_winrate;

(print ("sticking = " ^ Real.toString(stick_winrate) ^ "% win rate\n");
 print ("swapping = " ^ Real.toString(swap_winrate)  ^ "% win rate\n"));
