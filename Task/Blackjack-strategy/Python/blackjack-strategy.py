import random
import math
import time # Only needed for seeding if specific time-based seed is desired
from dataclasses import dataclass
from typing import List, Tuple # Optional: For type hinting

# Represents Deck: [total_cards, count_ace, count_2, ..., count_9, count_10s]
# Index 0: Deck size
# Index 1-9: Count of cards 1 (Ace) through 9
# Index 10: Count of 10, J, Q, K (all value 10)
Deck = List[int]

@dataclass(slots=True)
class ActionGain:
    action: str
    gain: float

def new_deck() -> Deck:
    """Creates a standard 52-card deck representation."""
    # 0:size, 1:A, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9, 10:T/J/Q/K
    return [52, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16]

def dealer_probs(up_card: int, start_deck: Deck) -> List[float]:
    """
    Returns probabilities of dealer eventually getting:
    [17, 18, 19, 20, 21(non-BJ), BJ(0.0 after norm), Bust]
    Assumes dealer already checked for BJ, 1 deck, stands on soft 17.
    """
    res = [0.0] * 7  # Results: 0:17, 1:18, 2:19, 3:20, 4:21(non-BJ), 5:BJ, 6:Bust

    # --- Nested function for recursion ---
    def _calculate_recursive(level: int, current_deck: Deck, current_score: int,
                             current_elevens: int, current_prob: float):
        nonlocal res # Allow modification of res from outer scope

        for c in range(1, 11):  # Card values 1 (Ace) to 10
            if current_deck[c] == 0:
                continue # Card no longer present

            # --- Create copies for this path ---
            deck = current_deck.copy() # VERY IMPORTANT: Copy list for this recursive path
            score = current_score
            eleven = current_elevens
            prob = current_prob

            # --- Calculate score and probability with the new card 'c' ---
            card_val = c
            score += card_val
            if card_val == 1: # Ace
                score += 10  # Count Ace as 11 initially
                eleven += 1

            # Probability of drawing this card 'c'
            prob *= deck[c] / deck[0]

            # Handle busting with Aces
            if score > 21 and eleven > 0:
                score -= 10
                eleven -= 1

            # Update deck state *after* calculating probability
            deck[c] -= 1
            deck[0] -= 1

            # --- Check end conditions or recurse ---
            # Initial check for dealer BJ (will be normalized out later)
            is_initial_bj = (level == 0 and
                             ((up_card == 1 and c == 10) or (up_card == 10 and c == 1)))

            if is_initial_bj:
                 res[5] += prob # Blackjack
            elif 17 <= score <= 21:
                res[score - 17] += prob # Final score 17 to 21 (non-BJ)
            elif score > 21: # Must be bust (eleven == 0 checked implicitly by logic)
                res[6] += prob # Bust
            else:
                # Continue drawing cards - recurse
                _calculate_recursive(level + 1, deck, score, eleven, prob)

    # --- Initial setup for recursion ---
    initial_deck = start_deck.copy() # Start with a copy
    initial_score = up_card
    initial_elevens = 0
    if up_card == 1: # Ace
        initial_score = 11
        initial_elevens = 1

    _calculate_recursive(0, initial_deck, initial_score, initial_elevens, 1.0)

    # --- Normalize probabilities: Dealer cannot have BJ if player gets to play ---
    prob_no_blackjack = 1.0 - res[5]
    if prob_no_blackjack <= 0: # Avoid division by zero if somehow only BJ is possible
         # This case should be rare/impossible if deck has > 2 cards
         # If it happens, assume uniform distribution over non-BJ outcomes or handle error
         # For simplicity, just return zeros, but a real implementation might need robust handling
         print(f"Warning: Prob no blackjack is {prob_no_blackjack} for upcard {up_card}. Deck: {start_deck}")
         # A pragmatic approach if this happens is to return a default non-commital distribution
         # return [0.15]*5 + [0.0, 0.25] # Example default
         # Or handle based on specific rules/edge cases.
         # Let's normalize what we have, even if pnbj is tiny.
         if prob_no_blackjack < 1e-9: prob_no_blackjack = 1e-9 # Floor it


    # Normalize other probabilities
    for i in range(len(res)):
        if i != 5: # Don't normalize the BJ prob itself yet
            res[i] /= prob_no_blackjack

    res[5] = 0.0 # Final probability of dealer BJ is 0 in this context

    # Final sanity check/renormalization (optional, corrects minor float errors)
    total_prob = sum(res)
    if abs(total_prob - 1.0) > 1e-6:
        # print(f"Warning: Dealer probs sum to {total_prob}, renormalizing. Upcard: {up_card}")
        if total_prob > 1e-9:
           for i in range(len(res)):
               res[i] /= total_prob

    return res

def dealer_chart():
    """Prints chart of dealer probabilities."""
    print("Dealer Probabilities, Stands on Soft 17, 1 Deck, U.S Rules")
    print("Up Card     17        18        19        20        21       Bust")
    print("-------------------------------------------------------------------")
    base_deck = new_deck()

    for uc in range(1, 11): # Up cards Ace (1) to 10
        deck = base_deck.copy()
        # Remove up card from the deck *before* calculating probabilities
        if deck[uc] > 0:
            deck[uc] -= 1
            deck[0] -= 1
        else:
            print(f"Error: Up card {uc} not in deck for dealer chart?")
            continue # Should not happen with a fresh deck

        # Calculate probabilities for the dealer drawing *more* cards
        dp = dealer_probs(uc, deck)

        uc_str = f"{uc:3d}" if uc > 1 else "Ace"
        print(f"{uc_str:<8s} ", end="")
        # Print probs for 17, 18, 19, 20, 21(non-BJ), Bust
        print(f"{dp[0]: .5f}  {dp[1]: .5f}  {dp[2]: .5f}  {dp[3]: .5f}  {dp[4]: .5f}  {dp[6]: .5f}")

def calc_gain(pscore: int, dp: List[float]) -> float:
    """Calculates player gain for a given player score and dealer probabilities."""
    # dp indices: 0:17, 1:18, 2:19, 3:20, 4:21(non-BJ), 5:BJ(0), 6:Bust
    eg = 0.0
    if pscore == 21: # Player non-BJ 21
        # Wins if dealer has 17-20 or busts
        eg += dp[0] + dp[1] + dp[2] + dp[3] + dp[6]
        # Push if dealer has 21
        # eg += 0 * dp[4]
    elif pscore == 20:
        eg += dp[0] + dp[1] + dp[2] + dp[6] # Win vs 17, 18, 19, Bust
        # Push vs 20
        # eg += 0 * dp[3]
        eg -= dp[4] # Lose vs 21
    elif pscore == 19:
        eg += dp[0] + dp[1] + dp[6] # Win vs 17, 18, Bust
        # Push vs 19
        # eg += 0 * dp[2]
        eg -= dp[3] + dp[4] # Lose vs 20, 21
    elif pscore == 18:
        eg += dp[0] + dp[6] # Win vs 17, Bust
        # Push vs 18
        # eg += 0 * dp[1]
        eg -= dp[2] + dp[3] + dp[4] # Lose vs 19, 20, 21
    elif pscore == 17:
        eg += dp[6] # Win vs Bust
        # Push vs 17
        # eg += 0 * dp[0]
        eg -= dp[1] + dp[2] + dp[3] + dp[4] # Lose vs 18, 19, 20, 21
    elif pscore > 21: # Player Bust
        eg = -1.0
    # Implicitly handles pscore < 17 (not possible when standing with 2 cards,
    # but handled in recursive gain calcs where player might stand early)
    # If pscore < 17 was possible here:
    #   eg += dp[6] # Win if dealer busts
    #   eg -= (1.0 - dp[6]) # Lose if dealer does not bust
    return eg


def player_gain_hit_once(card1: int, card2: int, uc: int, start_deck: Deck) -> float:
    """Expected gain if player hits exactly once, then stands."""
    eg = 0.0
    player_score = card1 + card2
    player_eleven = 0
    if card1 == 1:
        player_score += 10
        player_eleven += 1
    if card2 == 1 and card1 != 1: # Avoid double counting pair of Aces initially
         player_score += 10
         player_eleven +=1
    elif card1 == 1 and card2 == 1:
        player_score = 12 # Soft 12 (treat one as 11, one as 1)
        player_eleven = 1 # Representing one Ace counts as 11

    # Iterate through possible cards 'c' the player might draw
    for c in range(1, 11):
        if start_deck[c] == 0:
            continue

        deck = start_deck.copy() # Copy deck for this simulation path
        prob_c = deck[c] / deck[0]

        # Update deck
        deck[c] -= 1
        deck[0] -= 1

        # Calculate player's score after hitting
        score_after_hit = player_score + c
        eleven_after_hit = player_eleven
        if c == 1: # Drew an Ace
            score_after_hit += 10
            eleven_after_hit += 1

        # Adjust for bust with Aces
        if score_after_hit > 21 and eleven_after_hit > 0:
            score_after_hit -= 10
            eleven_after_hit -= 1 # Demoted an Ace

        # Calculate gain for this outcome
        if score_after_hit > 21:
            eg -= prob_c # Player busts, loses 1 unit
        else:
            # Player stands, calculate dealer probabilities with the remaining deck
            dp = dealer_probs(uc, deck)
            eg += calc_gain(score_after_hit, dp) * prob_c

    return eg

def player_gain_hit_strategy(card1: int, card2: int, uc: int, start_deck: Deck) -> float:
    """
    Expected gain if player hits according to strategy tables (rounds >= 2).
    Uses global h_table2, s_table2 (must be computed beforehand).
    """
    total_expected_gain = 0.0

    # Map dealer up card value (1-10) to table index (0-9)
    # Ace (1) -> 9, 2 -> 0, 3 -> 1, ..., 10 -> 8
    uc_index = 9 if uc == 1 else uc - 2


    # --- Nested function for recursive calculation ---
    def _calculate_recursive(level: int, current_deck: Deck, current_score: int,
                             current_elevens: int, current_prob: float):
        nonlocal total_expected_gain

        # Check player standing condition based on Round >= 2 strategy
        # These conditions match the Go code's logic within playerGain2's recursion
        should_stand = False
        if current_score <= 21:
            if current_elevens == 0: # Hard hand
                # Stand on hard 17 or more
                if current_score >= 17: should_stand = True
                # Stand on hard 13-16 vs dealer 2-6
                elif current_score >= 13 and uc < 7: should_stand = True
                 # Stand on hard 12 vs dealer 4-6
                elif current_score == 12 and 4 <= uc <= 6: should_stand = True
            else: # Soft hand (at least one Ace as 11)
                # Stand on soft 19 or more
                 if current_score >= 19: should_stand = True
                 # Stand on soft 18 vs dealer not 9, 10, A
                 elif current_score == 18 and uc != 9 and uc != 10 and uc != 1: should_stand = True

        if should_stand:
            dp = dealer_probs(uc, current_deck)
            gain = calc_gain(current_score, dp)
            total_expected_gain += gain * current_prob
            return # End recursion for this path

        # If not standing, consider hitting - iterate through possible next cards
        for c in range(1, 11):
            if current_deck[c] == 0:
                continue

            # --- Setup for next recursive step ---
            deck = current_deck.copy()
            prob_c = deck[c] / deck[0]
            next_prob = current_prob * prob_c

            deck[c] -= 1
            deck[0] -= 1

            score_after_hit = current_score + c
            eleven_after_hit = current_elevens
            if c == 1:
                score_after_hit += 10
                eleven_after_hit += 1

            if score_after_hit > 21 and eleven_after_hit > 0:
                score_after_hit -= 10
                eleven_after_hit -= 1

            if score_after_hit > 21: # Player busts
                total_expected_gain -= next_prob # Lose 1 unit * probability of this path
            else:
                 # Recurse: Player hits again based on strategy (implicitly handled by next call)
                _calculate_recursive(level + 1, deck, score_after_hit,
                                     eleven_after_hit, next_prob)

    # --- Initial setup for the first hit ---
    initial_score = card1 + card2
    initial_elevens = 0
    if card1 == 1:
        initial_score += 10
        initial_elevens += 1
    if card2 == 1 and card1 != 1:
        initial_score += 10
        initial_elevens += 1
    elif card1 == 1 and card2 == 1: # Pair of Aces
        initial_score = 12 # Start as Soft 12
        initial_elevens = 1

    # Start the recursive calculation
    _calculate_recursive(0, start_deck.copy(), initial_score, initial_elevens, 1.0)

    return total_expected_gain


# --- Functions to calculate expected gains for each action vs all up cards ---

def calculate_stand_gains(card1: int, card2: int) -> List[float]:
    """Returns expected gains for STANDING with card1, card2 vs dealer up cards 2-A."""
    base_deck = new_deck()
    # Remove player's cards
    if base_deck[card1] > 0: base_deck[card1] -= 1
    else: raise ValueError(f"Card {card1} not in deck for stand")
    if base_deck[card2] > 0: base_deck[card2] -= 1
    else: raise ValueError(f"Card {card2} not in deck for stand")
    base_deck[0] -= 2

    pscore = card1 + card2
    if card1 == 1 or card2 == 1:
        pscore += 10 # Count one Ace as 11
        if card1 == 1 and card2 == 1: # AA starts as 12 (Soft 12)
            pscore = 12

    expected_gains = [0.0] * 10 # Index 0 for dealer 2, ..., 8 for T, 9 for A

    for uc in range(1, 11): # Dealer up card Ace (1) to 10
        deck = base_deck.copy()
        # Remove dealer's up card
        if deck[uc] > 0:
            deck[uc] -= 1
            deck[0] -= 1
        else:
            # This can happen if player has JJ and dealer shows J, for example
            # print(f"Warning: Dealer up card {uc} count is zero. Player: {card1},{card2}. Skipping.")
            continue # Skip this up card if it's not available

        dp = dealer_probs(uc, deck)
        eg = calc_gain(pscore, dp)

        # Store gain in the correct index (2->0, ..., T->8, A->9)
        uc_index = 9 if uc == 1 else uc - 2
        expected_gains[uc_index] = eg

    return expected_gains

def calculate_hit_gains(card1: int, card2: int, hit_once: bool) -> List[float]:
    """Returns expected gains for HITTING with card1, card2 vs dealer up cards 2-A."""
    base_deck = new_deck()
    if base_deck[card1] > 0: base_deck[card1] -= 1
    else: raise ValueError(f"Card {card1} not in deck for hit")
    if base_deck[card2] > 0: base_deck[card2] -= 1
    else: raise ValueError(f"Card {card2} not in deck for hit")
    base_deck[0] -= 2

    expected_gains = [0.0] * 10

    for uc in range(1, 11):
        deck = base_deck.copy()
        if deck[uc] > 0:
            deck[uc] -= 1
            deck[0] -= 1
        else:
            continue # Skip if up card not available

        if hit_once:
            peg = player_gain_hit_once(card1, card2, uc, deck)
        else:
            # Assumes h_table2 and s_table2 are globally computed
            peg = player_gain_hit_strategy(card1, card2, uc, deck)

        uc_index = 9 if uc == 1 else uc - 2
        expected_gains[uc_index] = peg

    return expected_gains

def calculate_double_gains(card1: int, card2: int) -> List[float]:
    """Returns expected gains for DOUBLING with card1, card2 vs dealer up cards 2-A."""
    # Doubling means hitting once, standing, and doubling the stake
    gains_hit_once = calculate_hit_gains(card1, card2, hit_once=True)
    return [gain * 2.0 for gain in gains_hit_once]

def calculate_split_gains(card: int) -> List[float]:
    """
    Returns expected gains for SPLITTING a pair of 'card' vs dealer up cards 2-A.
    Assumes no resplit, no double after split. Plays subsequent hands by R2+ strategy.
    """
    if card < 1 or card > 10: raise ValueError("Invalid card for split")

    base_deck = new_deck()
    if base_deck[card] >= 2:
        base_deck[card] -= 2
        base_deck[0] -= 2
    else:
        raise ValueError(f"Not enough cards ({base_deck[card]}) to split {card}s")

    overall_gains = [0.0] * 10 # For dealer 2-A

    # Iterate through dealer up cards
    for uc in range(1, 11):
        deck1 = base_deck.copy() # Deck after removing player pair
        if deck1[uc] == 0: continue # Skip if uc not available
        deck1[uc] -= 1
        deck1[0] -= 1

        uc_index = 9 if uc == 1 else uc - 2 # Table index for this up card

        # Calculate expected gain for ONE of the split hands
        split_hand_gain = 0.0

        # Iterate through possible second cards 'c' for the *first* split hand
        for c in range(1, 11):
            if deck1[c] == 0: continue # Card c not available

            deck2 = deck1.copy() # Deck after removing pair and uc
            prob_c = deck2[c] / deck2[0] # Probability of drawing c

            deck2[c] -= 1
            deck2[0] -= 1 # Deck for playing out the hand starting card,c

            # --- Determine the state of the hand (card, c) ---
            score = card + c
            elevens = 0
            if card == 1: # Original card was Ace
                score = 11 + c # Start with first Ace as 11
                elevens = 1
            if c == 1: # Second card is Ace
                score += 10 # Count second Ace as 11 initially
                elevens += 1

            # Handle initial Ace adjustments (e.g., A,A -> score 12, elevens 1)
            if score > 21 and elevens > 0:
                score -= 10
                elevens -= 1
            # Special case: Player gets Blackjack on split (e.g. split 8s, draw A)
            # Note: Usually split Aces drawing a 10 is just 21, not BJ.
            # The Go code checks score == 21 after getting card c. Let's refine.
            is_split_blackjack = False # Standard rules: BJ only on first two cards
            # However, the Go code awarded 1.5x for A,10 or 10,A after split. Replicating that:
            if card == 1 and c == 10: is_split_blackjack = True
            if card == 10 and c == 1: is_split_blackjack = True

            gain_for_this_c = 0.0
            if is_split_blackjack:
                 # Assumes dealer doesn't have BJ (checked earlier)
                 gain_for_this_c = 1.5 # Win 1.5x
            elif score > 21: # Immediate bust after second card (e.g. split Ts, draw T)
                gain_for_this_c = -1.0 # Lose 1x
            else:
                # --- Hand (card, c) is playable, determine strategy (R2+) ---
                action = ""
                 # Use R2+ tables (no double/split)
                if elevens > 0: # Soft Hand
                     if 12 <= score <= 21: # Index is score - 12
                         action = s_table2[score - 12][uc_index]
                     else: action = "H" # Should hit soft hands < 12 (impossible here?)
                else: # Hard Hand
                     if 4 <= score <= 21: # Index is score - 4
                        action = h_table2[score - 4][uc_index]
                     else: action = "H" # Should hit hard hands < 4 (impossible)

                # --- Calculate gain based on action ---
                if action == "S":
                    dp = dealer_probs(uc, deck2) # Use deck after drawing c
                    gain_for_this_c = calc_gain(score, dp)
                elif action == "H":
                    # Hit according to R2+ strategy - use player_gain_hit_strategy
                    # Need to pass the state *after* drawing card 'c'
                    # We can simulate this by calling it with 'card' and 'c' as initial cards
                    # and deck2 as the starting deck.
                    gain_for_this_c = player_gain_hit_strategy(card, c, uc, deck2)
                else:
                     print(f"Error: Unexpected action '{action}' in split calculation")
                     gain_for_this_c = -1 # Penalize errors

            split_hand_gain += gain_for_this_c * prob_c

        # Store the total gain (for BOTH hands)
        # Assumes symmetry: gain of second hand is same as first (simplification)
        overall_gains[uc_index] = split_hand_gain * 2.0

    return overall_gains


# --- Helper Functions ---

def get_best_action(action_gains: List[ActionGain]) -> str:
    """Finds the action with the highest gain."""
    if not action_gains:
        return "Error" # Or some default
    best_action = max(action_gains, key=lambda ag: ag.gain)
    return best_action.action

def print_header(title: str):
    """Prints chart title and header."""
    print(title)
    print("P/D     2      3      4      5      6      7      8      9      T      A")
    print("-" * 74) # Adjusted width

def print_pair_prefix(c: int):
    """Prints the prefix for a pair row (e.g., AA, 88, TT)."""
    if c == 1:   print("AA   ", end="")
    elif c == 10: print("TT   ", end="")
    else:        print(f"{c}{c}   ", end="")

# --- Global Strategy Tables (to be computed) ---
# Dimensions based on Go code:
# H: Hard 5-19 (15 rows) x Up 2-A (10 cols)
h_table = [[""] * 10 for _ in range(15)]
# S: Soft 13-20 (A2-A9) (8 rows) x Up 2-A (10 cols)
s_table = [[""] * 10 for _ in range(8)]
# P: Pairs A-T (10 rows) x Up 2-A (10 cols)
p_table = [[""] * 10 for _ in range(10)]
# H2: Hard 4-21 (18 rows) x Up 2-A (10 cols) - R2+ Strategy
h_table2 = [[""] * 10 for _ in range(18)]
# S2: Soft 12-21 (AA, A2-AT) (10 rows) x Up 2-A (10 cols) - R2+ Strategy
s_table2 = [[""] * 10 for _ in range(10)]


# --- Simulation Functions ---

def dealer_play(pscore: int, next_card_idx: int, cards: List[int], d_hand: List[int]) -> Tuple[float, int]:
    """
    Simulates dealer's play given player's final score.
    Returns (player_gain_for_this_hand, updated_next_card_idx).
    """
    d_cards = d_hand[:] # Copy dealer's initial hand
    d_score = sum(d_cards)
    aces = d_cards.count(1)
    if aces > 0:
        d_score += 10 # Count first ace as 11

    while True:
        # Adjust for aces if busting
        if d_score > 21 and aces > 0:
            d_score -= 10
            aces -= 1

        # Dealer stands or busts
        if d_score >= 17:
            break

        # Dealer hits
        if next_card_idx >= len(cards):
            print("Error: Deck ran out during dealer play!")
            # Decide how to handle this - maybe a push? Or assume dealer stands?
            break # Stop drawing

        nc = cards[next_card_idx]
        next_card_idx += 1
        d_cards.append(nc)
        d_score += nc
        if nc == 1: # Drew an Ace
             d_score += 10 # Count initially as 11
             aces += 1

    # Determine outcome
    if d_score > 21: # Dealer busts
        return 1.0, next_card_idx
    elif d_score > pscore: # Dealer wins
        return -1.0, next_card_idx
    elif d_score == pscore: # Push
        return 0.0, next_card_idx
    else: # Player wins (pscore > d_score)
        return 1.0, next_card_idx

def player_play() -> Tuple[float, float]:
    """
    Simulates one full player hand using computed strategy tables.
    Returns (total_gain_for_round, total_stake_for_round).
    """
    # 1. Create and shuffle deck
    # Card values: 1 (Ace), 2-9, 10 (for T, J, Q, K)
    card_values = list(range(1, 10)) + [10] * 4
    full_deck = card_values * 4 # 4 suits
    random.shuffle(full_deck)
    cards = full_deck # Use the shuffled deck directly

    # 2. Initial Deal
    if len(cards) < 4:
        print("Error: Not enough cards to deal.")
        return 0.0, 0.0 # Should not happen with full deck
    p_hand = [cards.pop(0), cards.pop(0)]
    d_hand = [cards.pop(0), cards.pop(0)]
    # In Python, pop(0) is inefficient for lists. For high-performance sims,
    # collections.deque or managing an index is better. Sticking to list pop
    # for closer translation of the Go logic (which used an index `next`).
    # Let's switch to index tracking like Go:
    all_cards = full_deck
    next_card_idx = 0
    p_hand = [all_cards[0], all_cards[1]]
    d_hand = [all_cards[2], all_cards[3]]
    next_card_idx = 4


    # 3. Check for Blackjacks
    p_val1, p_val2 = p_hand
    d_val1, d_val2 = d_hand

    p_is_ace = (p_val1 == 1 or p_val2 == 1)
    p_is_ten = (p_val1 == 10 or p_val2 == 10)
    d_is_ace = (d_val1 == 1 or d_val2 == 1)
    d_is_ten = (d_val1 == 10 or d_val2 == 10)

    p_has_bj = p_is_ace and p_is_ten
    d_has_bj = d_is_ace and d_is_ten

    if d_has_bj:
        if p_has_bj:
            return 0.0, 1.0 # Push
        else:
            return -1.0, 1.0 # Player loses to dealer BJ
    elif p_has_bj:
        return 1.5, 1.0 # Player wins with BJ

    # --- No initial Blackjacks, play the hand ---
    stake = 1.0
    final_scores = [0, 0] # Player final scores (up to 2 hands for split)
                          # 0 means hand not played/busted early
                          # Use 22+ to signify bust

    # --- Nested 'hit' function (like Go closure) ---
    def perform_hit(hand_idx: int, current_score: int, current_aces: int,
                    is_double: bool, current_next_idx: int) -> Tuple[int, int, int]:
        """
        Handles hitting logic based on R2+ strategy.
        Modifies final_scores directly.
        Returns (final_score_for_hand, final_aces_count, updated_next_idx).
        """
        score = current_score
        aces = current_aces
        next_idx = current_next_idx

        while True:
            if next_idx >= len(all_cards):
                print("Error: Deck ran out during player hit!")
                final_scores[hand_idx] = score if score <= 21 else 22 # Bust if over
                return score, aces, next_idx # Return current state

            nc = all_cards[next_idx]
            next_idx += 1
            score += nc
            if nc == 1:
                score += 10 # Count Ace as 11
                aces += 1

            # Adjust for bust with Aces
            while score > 21 and aces > 0:
                score -= 10
                aces -= 1

            # Check for bust
            if score > 21:
                final_scores[hand_idx] = 22 # Mark as bust
                return score, aces, next_idx

            # If it was a double, player only gets one card
            if is_double:
                final_scores[hand_idx] = score
                return score, aces, next_idx

            # --- Not a double, check strategy for next move (R2+) ---
            # Determine action based on h_table2 / s_table2
            uc_value = d_hand[0] # Dealer's up card value
            uc_idx = 9 if uc_value == 1 else uc_value - 2

            action = "S" # Default to Stand
            if aces == 0: # Hard hand
                if 4 <= score <= 21:
                     action = h_table2[score - 4][uc_idx]
                else: action = "H" # Should hit below 4
            else: # Soft hand
                 if 12 <= score <= 21:
                     action = s_table2[score - 12][uc_idx]
                 else: action = "H" # Should hit below soft 12

            if action == "S":
                final_scores[hand_idx] = score
                return score, aces, next_idx
            elif action == "H":
                 continue # Loop again to draw another card
            else:
                 print(f"Error: Invalid action '{action}' in R2+ strategy during hit")
                 final_scores[hand_idx] = score # Stand on error
                 return score, aces, next_idx
    # --- End of nested hit function ---

    # --- Determine initial hand type and strategy (Round 1) ---
    p_card1, p_card2 = p_hand
    score = p_card1 + p_card2
    aces = 0
    kind = ""
    action = ""
    uc_value = d_hand[0]
    uc_idx = 9 if uc_value == 1 else uc_value - 2

    if p_card1 == p_card2:
        kind = "pair"
        if p_card1 == 1: # Pair of Aces
            score = 12 # Soft 12
            aces = 1 # One Ace counts as 11
        action = p_table[p_card1 - 1][uc_idx]
    elif p_card1 == 1 or p_card2 == 1:
        kind = "soft"
        score += 10 # Count Ace as 11
        aces = 1
        other_card = p_card2 if p_card1 == 1 else p_card1
        # s_table index is based on the non-Ace card (2-9 map to indices 0-7)
        if 2 <= other_card <= 9:
             action = s_table[other_card - 2][uc_idx]
        else: # A, T - should be score 21, Stand
             action = "S"
    else:
        kind = "hard"
        aces = 0
        # h_table index is based on score (5-19 map to indices 0-14)
        if 5 <= score <= 19:
            action = h_table[score - 5][uc_idx]
        elif score >= 20: action = "S" # Stand on 20, 21
        else: action = "H" # Hit below 5

    # --- Execute Round 1 Action ---
    if action == "S":
        final_scores[0] = score
    elif action == "H":
        _, _, next_card_idx = perform_hit(0, score, aces, False, next_card_idx)
    elif action == "D":
        stake = 2.0
        _, _, next_card_idx = perform_hit(0, score, aces, True, next_card_idx)
    elif action == "P":
        # Play two hands starting with one card from the pair
        card_from_pair = p_card1
        # Hand 1
        score1 = card_from_pair
        aces1 = 0
        if score1 == 1:
            score1 = 11
            aces1 = 1
        _, _, next_card_idx = perform_hit(0, score1, aces1, False, next_card_idx)

        # Hand 2
        score2 = card_from_pair
        aces2 = 0
        if score2 == 1:
             score2 = 11
             aces2 = 1
        # Pass the updated next_card_idx from playing the first hand
        _, _, next_card_idx = perform_hit(1, score2, aces2, False, next_card_idx)
        stake = 2.0 # Stake is doubled for split
    else:
        print(f"Error: Unknown action '{action}' from strategy table.")
        final_scores[0] = score # Default to stand on error

    # --- Dealer Play and Calculate Gain ---
    total_gain = 0.0

    # Hand 1 result
    if final_scores[0] > 0: # Hand was played
        if final_scores[0] <= 21:
             gain1, next_card_idx = dealer_play(final_scores[0], next_card_idx, all_cards, d_hand)
             # If action was Double, the gain/loss applies to 2 units
             # If action was Split, the gain/loss applies to 1 unit (per hand)
             hand1_stake = 2.0 if action == "D" else 1.0
             total_gain += gain1 * hand1_stake
        else: # Player busted on hand 1
             hand1_stake = 2.0 if action == "D" else 1.0
             total_gain -= 1.0 * hand1_stake

    # Hand 2 result (only if split occurred)
    if final_scores[1] > 0: # Hand 2 was played (only happens on Split)
        if final_scores[1] <= 21:
            # Pass the updated next_card_idx from playing Hand 1 / Dealer for Hand 1
            gain2, next_card_idx = dealer_play(final_scores[1], next_card_idx, all_cards, d_hand)
            total_gain += gain2 * 1.0 # Stake for second split hand is 1 unit
        else: # Player busted on hand 2
            total_gain -= 1.0 * 1.0

    return total_gain, stake


def simulate(per_day: int, days: int):
    """Simulates 'per_day' blackjack games for 'days' days."""
    win_days, lose_days, even_days = 0, 0, 0
    big_win, big_loss = 0.0, 0.0
    total_gain, total_stake = 0.0, 0.0

    for d in range(days):
        daily_gain, daily_stake = 0.0, 0.0
        for p in range(per_day):
            gain, stake = player_play()
            daily_gain += gain
            daily_stake += stake

        if daily_gain > 1e-9: # Use tolerance for float comparison
            win_days += 1
        elif daily_gain < -1e-9:
            lose_days += 1
        else:
            even_days += 1

        big_win = max(big_win, daily_gain)
        big_loss = max(big_loss, -daily_gain) # Store loss as positive value

        total_gain += daily_gain
        total_stake += daily_stake

    print(f"\nAfter playing {per_day} times a day for {days} days:")
    print(f"Winning days   : {win_days}")
    print(f"Losing days    : {lose_days}")
    print(f"Breakeven days : {even_days}")
    print(f"Biggest win    : {big_win:.2f}")
    print(f"Biggest loss   : {big_loss:.2f}")

    if total_stake < 1e-9:
         print("Total staked is zero, cannot calculate percentage.")
         return

    if total_gain < 0:
        print(f"Total loss     : {-total_gain:.2f}")
        print(f"Total staked   : {total_stake:.2f}")
        print(f"Loss % staked  : {-total_gain / total_stake * 100:.3f}%")
    else:
        print(f"Total win      : {total_gain:.2f}")
        print(f"Total staked   : {total_stake:.2f}")
        print(f"Win % staked   : {total_gain / total_stake * 100:.3f}%")


# ===========================================
# Main Execution Logic (like Go's main func)
# ===========================================
if __name__ == "__main__":
    print("--- Calculating Blackjack Strategy ---")

    # Print dealer probabilities chart
    dealer_chart()

    # --- Calculate Hard Hand Expected Gains (Round 1) ---
    print("\n--- Calculating Hard Hand Gains (R1) ---")
    hard_tuples = [
        (2, 3), (2, 4), (2, 5), (3, 4), (2, 6), (3, 5), (2, 7), (3, 6),
        (4, 5), (2, 8), (3, 7), (4, 6), (2, 9), (3, 8), (4, 7), (5, 6),
        (2, 10), (3, 9), (4, 8), (5, 7), (3, 10), (4, 9), (5, 8), (6, 7),
        (4, 10), (5, 9), (6, 8), (5, 10), (6, 9), (7, 8), (6, 10), (7, 9),
        (7, 10), (8, 9), (8, 10), (9, 10)
    ]
    # Counts per score: 5(1), 6(1), 7(2), 8(2), 9(3), 10(3), 11(4), 12(4),
    # 13(4), 14(3), 15(3), 16(2), 17(2), 18(1), 19(1)
    hard_counts = {i: 0 for i in range(5, 20)}
    for t in hard_tuples:
        hard_counts[t[0] + t[1]] += 1

    # Store summed gains per score (5-19)
    segs_hard_sum = [[0.0] * 10 for _ in range(15)] # Stand gains (score 5-19)
    hegs_hard_sum = [[0.0] * 10 for _ in range(15)] # Hit gains (R2+ strategy)
    degs_hard_sum = [[0.0] * 10 for _ in range(15)] # Double gains

    # --- Pre-calculate R2+ strategy tables needed for 'Hit' and 'Split' ---
    # First, roughly populate R2+ based on dummy R1 calculations (simplification)
    # This is slightly circular, but needed to run the gain funcs.
    # A more rigorous approach might iterate.
    # Calculate simplified R2+ Hard Table (needed for hit/split funcs)
    # We'll fill h_table2 more accurately *after* calculating R1 gains.
    # For now, make basic assumptions (hit below 17, stand 17+)
    print("Pre-calculating basic R2+ tables...")
    for i in range(18): # score 4-21
        score = i + 4
        for j in range(10): # uc 2-A
            h_table2[i][j] = "H" if score < 17 else "S"
            # Basic Hard 12-16 vs low dealer upcard stand rule (approx)
            uc_val = 1 if j == 9 else j + 2
            if 12 <= score <= 16 and uc_val < 7 : h_table2[i][j] = "S"
            if score == 12 and 4 <= uc_val <= 6: h_table2[i][j] = "S"


    # Basic R2+ Soft table (approximate: hit soft 17 or less, stand 18+)
    for i in range(10): # score 12-21
        score = i + 12
        for j in range(10): # uc 2-A
            s_table2[i][j] = "H" if score <= 17 else "S"
             # Stand soft 18 unless dealer shows 9, T, A (approx)
            uc_val = 1 if j == 9 else j + 2
            if score == 18 and uc_val != 9 and uc_val != 10 and uc_val != 1:
                 s_table2[i][j] = "S"


    print("Calculating R1 Gains (Stand, Hit, Double) for Hard Hands...")
    for c1, c2 in hard_tuples:
        score = c1 + c2
        idx = score - 5 # Index for 5-19 scores

        sg = calculate_stand_gains(c1, c2)
        hg = calculate_hit_gains(c1, c2, hit_once=False) # Use R2+ strategy for hit gain
        dg = calculate_double_gains(c1, c2)

        for j in range(10): # Dealer up card index
            segs_hard_sum[idx][j] += sg[j]
            hegs_hard_sum[idx][j] += hg[j]
            degs_hard_sum[idx][j] += dg[j]

    # Average the gains
    segs_hard = [[0.0] * 10 for _ in range(15)]
    hegs_hard = [[0.0] * 10 for _ in range(15)]
    degs_hard = [[0.0] * 10 for _ in range(15)]
    for i in range(15): # score 5-19
        score = i + 5
        count = hard_counts[score]
        if count > 0:
            for j in range(10):
                segs_hard[i][j] = segs_hard_sum[i][j] / count
                hegs_hard[i][j] = hegs_hard_sum[i][j] / count
                degs_hard[i][j] = degs_hard_sum[i][j] / count

    # --- Print Hard Hand Gain Tables (R1) ---
    print_header("\nHard Chart - Player Expected Gains per unit (Stand)")
    for i in range(15):
        print(f"{i+5:<2d}   ", end="")
        for j in range(10): print(f"{segs_hard[i][j]: 6.3f} ", end="")
        print()

    print_header("\nHard Chart - Player Expected Gains per unit (Hit)")
    for i in range(15):
        print(f"{i+5:<2d}   ", end="")
        for j in range(10): print(f"{hegs_hard[i][j]: 6.3f} ", end="")
        print()

    print_header("\nHard Chart - Player Expected Gains per original unit (Double)")
    for i in range(15):
        print(f"{i+5:<2d}   ", end="")
        for j in range(10): print(f"{degs_hard[i][j]: 6.3f} ", end="")
        print()

    # --- Compute and Print Hard Strategy Table (R1) ---
    print_header("\nHard Chart - Player Strategy (Round 1)")
    for i in range(15): # score 5-19
        score = i + 5
        print(f"{score:<2d}   ", end="")
        for j in range(10): # uc index 0-9
            # Decide best action: Stand, Hit, Double
            actions = [
                ActionGain("S", segs_hard[i][j]),
                ActionGain("H", hegs_hard[i][j])
            ]
            # Generally only double on 9, 10, 11 - but calc gain for all
            # Check if doubling is allowed/better
            # Basic rule: Only consider double if score is 9, 10, or 11
            # More accurate: Check gain always
            actions.append(ActionGain("D", degs_hard[i][j]))

            best = get_best_action(actions)
            # Don't double if gain is worse than hit/stand
            # Sometimes double gain is high but negative, still might be best action
            # Ensure Double is only chosen if positive gain? No, choose max EV.
            # Simplification: Basic Strategy often restricts doubling.
            # Let's stick to pure EV max for now.
            h_table[i][j] = best
            print(f"{best:>4s}   ", end="")
        print()

    # --- Compute and Print Hard Strategy Table (R2+) ---
    # Calculate gains for scores 4, 20, 21 needed for H2 table
    print("Calculating Gains for Hard 4, 20, 21...")
    sg4 = calculate_stand_gains(2, 2)
    hg4 = calculate_hit_gains(2, 2, False)
    sg20 = calculate_stand_gains(10, 10)
    hg20 = calculate_hit_gains(10, 10, False)
    sg21 = calculate_stand_gains(10, 1) # Hard 21 e.g. 10, 5, 6 or T,A initially
    hg21 = calculate_hit_gains(10, 1, False)

    # Combine gains for H2 table (scores 4-21)
    segs_hard2 = [[0.0] * 10 for _ in range(18)]
    hegs_hard2 = [[0.0] * 10 for _ in range(18)]

    segs_hard2[0] = sg4 # Score 4
    hegs_hard2[0] = hg4
    for i in range(15): # Scores 5-19 map to index 1-15
         segs_hard2[i+1] = segs_hard[i]
         hegs_hard2[i+1] = hegs_hard[i]
    segs_hard2[16] = sg20 # Score 20
    hegs_hard2[16] = hg20
    segs_hard2[17] = sg21 # Score 21
    hegs_hard2[17] = hg21

    print_header("\nHard Chart - Player Strategy (Round >= 2, No Doubling)")
    for i in range(18): # score 4-21
        score = i + 4
        print(f"{score:<2d}   ", end="")
        for j in range(10): # uc index 0-9
            # Decide best action: Stand or Hit only
            action = "S"
            if hegs_hard2[i][j] > segs_hard2[i][j]:
                action = "H"
            h_table2[i][j] = action # Update the pre-calculated table
            print(f"{action:>4s}   ", end="")
        print()

    # --- Calculate Soft Hand Expected Gains (R1) ---
    print("\n--- Calculating Soft Hand Gains (R1) ---")
    # Soft hands A,2 to A,9 (scores 13-20)
    segs_soft = [[0.0] * 10 for _ in range(8)] # Stand gains (A2-A9)
    hegs_soft = [[0.0] * 10 for _ in range(8)] # Hit gains (R2+ strategy)
    degs_soft = [[0.0] * 10 for _ in range(8)] # Double gains

    for card2 in range(2, 10): # A2 to A9
        idx = card2 - 2 # Index 0-7

        sg = calculate_stand_gains(1, card2)
        hg = calculate_hit_gains(1, card2, hit_once=False)
        dg = calculate_double_gains(1, card2)

        for j in range(10):
            segs_soft[idx][j] = sg[j]
            hegs_soft[idx][j] = hg[j]
            degs_soft[idx][j] = dg[j]

    # --- Print Soft Hand Gain Tables (R1) ---
    print_header("\nSoft Chart - Player Expected Gains per unit (Stand)")
    for i in range(8): print(f"A{i+2:<1d}   ", end=""); [print(f"{segs_soft[i][j]: 6.3f} ", end="") for j in range(10)]; print()
    print_header("\nSoft Chart - Player Expected Gains per unit (Hit)")
    for i in range(8): print(f"A{i+2:<1d}   ", end=""); [print(f"{hegs_soft[i][j]: 6.3f} ", end="") for j in range(10)]; print()
    print_header("\nSoft Chart - Player Expected Gains per original unit (Double)")
    for i in range(8): print(f"A{i+2:<1d}   ", end=""); [print(f"{degs_soft[i][j]: 6.3f} ", end="") for j in range(10)]; print()

    # --- Compute and Print Soft Strategy Table (R1) ---
    print_header("\nSoft Chart - Player Strategy (Round 1)")
    for i in range(8): # A2-A9
        card2 = i + 2
        print(f"A{card2:<1d}   ", end="")
        for j in range(10):
            actions = [
                ActionGain("S", segs_soft[i][j]),
                ActionGain("H", hegs_soft[i][j]),
                ActionGain("D", degs_soft[i][j])
            ]
            best = get_best_action(actions)
            s_table[i][j] = best
            print(f"{best:>4s}   ", end="")
        print()

    # --- Compute and Print Soft Strategy Table (R2+) ---
    print("Calculating Gains for Soft 12, 21...")
    sg12 = calculate_stand_gains(1, 1) # Soft 12 (A,A)
    hg12 = calculate_hit_gains(1, 1, False)
    # Use sg21, hg21 from Hard section (A,T treated same)

    # Combine gains for S2 table (scores 12-21)
    segs_soft2 = [[0.0] * 10 for _ in range(10)]
    hegs_soft2 = [[0.0] * 10 for _ in range(10)]

    segs_soft2[0] = sg12 # Score 12 (AA)
    hegs_soft2[0] = hg12
    for i in range(8): # Scores 13-20 (A2-A9) map to index 1-8
         segs_soft2[i+1] = segs_soft[i]
         hegs_soft2[i+1] = hegs_soft[i]
    segs_soft2[9] = sg21 # Score 21 (AT)
    hegs_soft2[9] = hg21

    print_header("\nSoft Chart - Player Strategy (Round >= 2, No Doubling)")
    for i in range(10): # score 12-21
        score = i + 12
        print(f"{score:<2d}   ", end="") # Print score (12=AA, 13=A2.. 21=AT)
        for j in range(10): # uc index 0-9
            action = "S"
            if hegs_soft2[i][j] > segs_soft2[i][j]:
                action = "H"
            s_table2[i][j] = action # Update the pre-calculated table
            print(f"{action:>4s}   ", end="")
        print()


    # --- Calculate Pairs Expected Gains (R1) ---
    print("\n--- Calculating Pairs Gains (R1) ---")
    segs_pair = [[0.0] * 10 for _ in range(10)] # Stand (AA-TT)
    hegs_pair = [[0.0] * 10 for _ in range(10)] # Hit
    degs_pair = [[0.0] * 10 for _ in range(10)] # Double
    pegs_pair = [[0.0] * 10 for _ in range(10)] # Split

    for card in range(1, 11): # Pair A to T
        idx = card - 1
        print(f"Calculating gains for pair {card}...")

        segs_pair[idx] = calculate_stand_gains(card, card)
        hegs_pair[idx] = calculate_hit_gains(card, card, False)
        # Doubling pairs like AA or TT is usually restricted or bad
        # Calculate gain anyway for comparison
        degs_pair[idx] = calculate_double_gains(card, card)
        pegs_pair[idx] = calculate_split_gains(card) # Uses R2+ strategy after split

    # --- Print Pairs Gain Tables (R1) ---
    print_header("\nPairs Chart - Player Expected Gains per unit (Stand)")
    for i in range(10): print_pair_prefix(i+1); [print(f"{segs_pair[i][j]: 6.3f} ", end="") for j in range(10)]; print()
    print_header("\nPairs Chart - Player Expected Gains per unit (Hit)")
    for i in range(10): print_pair_prefix(i+1); [print(f"{hegs_pair[i][j]: 6.3f} ", end="") for j in range(10)]; print()
    print_header("\nPairs Chart - Player Expected Gains per original unit (Double)")
    for i in range(10): print_pair_prefix(i+1); [print(f"{degs_pair[i][j]: 6.3f} ", end="") for j in range(10)]; print()
    print_header("\nPairs Chart - Player Expected Gains per original unit (Split)")
    for i in range(10): print_pair_prefix(i+1); [print(f"{pegs_pair[i][j]: 6.3f} ", end="") for j in range(10)]; print()

    # --- Compute and Print Pairs Strategy Table (R1) ---
    print_header("\nPairs Chart - Player Strategy (Round 1)")
    for i in range(10): # Pair A-T
        card = i + 1
        print_pair_prefix(card)
        for j in range(10):
            actions = [
                ActionGain("S", segs_pair[i][j]),
                ActionGain("H", hegs_pair[i][j]),
                ActionGain("D", degs_pair[i][j]),
                ActionGain("P", pegs_pair[i][j])
            ]
            # Basic Strategy rules often simplify:
            # - Never double pairs (except maybe 55?)
            # - Split some, hit/stand others
            # We choose purely based on max EV here
            best = get_best_action(actions)
            p_table[i][j] = best
            print(f"{best:>4s}   ", end="")
        print()

    print("\n--- Strategy Calculation Complete ---")


    # --- Run Simulation ---
    print("\n--- Running Simulation ---")
    # Seed the random number generator (optional, for reproducibility use a fixed seed)
    # random.seed(12345)
    random.seed() # Use default seeding (time/OS based)

    # Do 10 years of simulations (as in Go code)
    for i in range(1, 11):
        print(f"\nSimulation for Year {i}:")
        simulate(per_day=50, days=365)

    print("\n--- Simulation Complete ---")
