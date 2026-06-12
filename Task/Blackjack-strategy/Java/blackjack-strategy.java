import java.util.*;

public class BlackjackStrategy {

    static class Deck {
        int[] cards; // 0:deck size, 1-10: number of cards of that denomination

        Deck() {
            cards = new int[11];
            cards[0] = 52;
            for (int i = 1; i <= 9; i++) {
                cards[i] = 4;
            }
            cards[10] = 16; // 10, J, Q, K
        }

        Deck(Deck other) {
            cards = Arrays.copyOf(other.cards, 11);
        }
    }

    static class ActionGain {
        String action;
        double gain;

        ActionGain(String action, double gain) {
            this.action = action;
            this.gain = gain;
        }
    }

    // Strategy tables
    static String[][] hTable = new String[15][10];  // hard strategy (round 1)
    static String[][] sTable = new String[8][10];   // soft strategy (round 1)
    static String[][] pTable = new String[10][10];  // pairs strategy (round 1)
    static String[][] hTable2 = new String[18][10]; // hard strategy (round >= 2)
    static String[][] sTable2 = new String[10][10]; // soft strategy (round >= 2)

    static Random random = new Random();

    // Returns probabilities of dealer outcomes
    static double[] dealerProbs(int upCard, Deck startDeck) {
        double[] res = new double[7]; // 17, 18, 19, 20, 21, BJ(nil), bust
        Deck[] decks = new Deck[9];
        int[] scores = new int[9];
        int[] elevens = new int[9];
        double[] probs = new double[9];

        decks[0] = new Deck(startDeck);
        scores[0] = upCard;
        if (upCard == 1) {
            scores[0] = 11;
            elevens[0] = 1;
        }
        probs[0] = 1.0;

        dealerProbsRecursive(0, res, decks, scores, elevens, probs, upCard);

        // Adjust for no blackjack
        double pnbj = 1 - res[5];
        for (int i = 0; i < 7; i++) {
            res[i] /= pnbj;
        }
        res[5] = 0;
        return res;
    }

    static void dealerProbsRecursive(int lev, double[] res, Deck[] decks,
                                     int[] scores, int[] elevens, double[] probs, int upCard) {
        for (int c = 1; c <= 10; c++) {
            if (decks[lev].cards[c] == 0) continue;

            Deck deck = new Deck(decks[lev]);
            int score = scores[lev] + c;
            int eleven = elevens[lev];
            double prob = probs[lev];

            if (c == 1) {
                score += 10;
                eleven++;
            }
            prob *= (double)deck.cards[c] / deck.cards[0];

            if (score > 21 && eleven > 0) {
                score -= 10;
                eleven--;
            }

            if (lev == 0 && ((upCard == 1 && c == 10) || (upCard == 10 && c == 1))) {
                res[5] += prob; // blackjack
            } else if (score >= 17 && score <= 21) {
                res[score - 17] += prob;
            } else if (score > 21 && eleven == 0) {
                res[6] += prob; // bust
            } else {
                deck.cards[c]--;
                deck.cards[0]--;
                int lev2 = lev + 1;
                decks[lev2] = deck;
                scores[lev2] = score;
                elevens[lev2] = eleven;
                probs[lev2] = prob;
                dealerProbsRecursive(lev2, res, decks, scores, elevens, probs, upCard);
            }
        }
    }

    static void dealerChart() {
        System.out.println("Dealer Probabilities, Stands on Soft 17, 1 Deck, U.S Rules");
        System.out.println("Up Card     17        18        19        20        21       Bust");
        System.out.println("-------------------------------------------------------------------");

        Deck deck = new Deck();
        deck.cards[0] = 51;

        for (int uc = 1; uc <= 10; uc++) {
            Deck deck2 = new Deck(deck);
            deck2.cards[uc]--;
            double[] dp = dealerProbs(uc, deck2);

            if (uc > 1) {
                System.out.printf("%3d      ", uc);
            } else {
                System.out.print("Ace      ");
            }
            System.out.printf("%f  %f  %f  %f  %f  %f%n",
                dp[0], dp[1], dp[2], dp[3], dp[4], dp[6]);
        }
    }

    static double playerGain(int card1, int card2, int uc, Deck startDeck) {
        double eg = 0.0;
        Deck deck = new Deck(startDeck);
        int score = card1 + card2;
        boolean eleven = (card1 == 1 || card2 == 1);
        if (eleven) score += 10;

        for (int c = 1; c <= 10; c++) {
            if (deck.cards[c] == 0) continue;

            Deck deck2 = new Deck(deck);
            int score2 = score + c;
            boolean eleven2 = eleven;

            if (c == 1) {
                score2 += 10;
                eleven2 = true;
            }

            double prob = (double)deck2.cards[c] / deck2.cards[0];
            deck2.cards[c]--;
            deck2.cards[0]--;

            if (score2 > 21 && eleven2) {
                score2 -= 10;
            }

            if (score2 <= 21) {
                double[] dp = dealerProbs(uc, deck2);
                eg += calcGain(score2, dp) * prob;
            } else {
                eg -= prob;
            }
        }
        return eg;
    }

    static double playerGain2(int card1, int card2, int uc, Deck startDeck) {
        double[] eg = {0.0};
        Deck[] decks = new Deck[9];
        int[] scores = new int[9];
        int[] elevens = new int[9];
        double[] probs = new double[9];

        decks[0] = new Deck(startDeck);
        scores[0] = card1 + card2;
        if (card1 == 1 || card2 == 1) {
            scores[0] += 10;
            elevens[0] = 1;
        }
        probs[0] = 1.0;

        playerGain2Recursive(0, eg, decks, scores, elevens, probs, uc);
        return eg[0];
    }

    static void playerGain2Recursive(int lev, double[] eg, Deck[] decks,
                                     int[] scores, int[] elevens, double[] probs, int uc) {
        for (int c = 1; c <= 10; c++) {
            if (decks[lev].cards[c] == 0) continue;

            Deck deck = new Deck(decks[lev]);
            int score = scores[lev] + c;
            int eleven = elevens[lev];
            double prob = probs[lev];

            if (c == 1) {
                score += 10;
                eleven++;
            }
            prob *= (double)deck.cards[c] / deck.cards[0];

            if (score > 21 && eleven > 0) {
                score -= 10;
                eleven--;
            }

            deck.cards[c]--;
            deck.cards[0]--;

            boolean shouldStand = (eleven == 0 && (score >= 17 || (score >= 13 && uc < 7))) ||
                                 (eleven == 0 && score == 12 && uc >= 4 && uc <= 6) ||
                                 (eleven > 0 && score == 18 && uc != 9 && uc != 10) ||
                                 (eleven > 0 && score >= 19);

            if (shouldStand && score <= 21) {
                double[] dp = dealerProbs(uc, deck);
                eg[0] += calcGain(score, dp) * prob;
            } else if (score > 21 && eleven == 0) {
                eg[0] -= prob;
            } else {
                int lev2 = lev + 1;
                decks[lev2] = deck;
                scores[lev2] = score;
                elevens[lev2] = eleven;
                probs[lev2] = prob;
                playerGain2Recursive(lev2, eg, decks, scores, elevens, probs, uc);
            }
        }
    }

    static double calcGain(int pscore, double[] dp) {
        double eg = 0.0;
        switch (pscore) {
            case 17:
                eg += dp[6];
                eg -= dp[1] + dp[2] + dp[3] + dp[4];
                break;
            case 18:
                eg += dp[0] + dp[6];
                eg -= dp[2] + dp[3] + dp[4];
                break;
            case 19:
                eg += dp[0] + dp[1] + dp[6];
                eg -= dp[3] + dp[4];
                break;
            case 20:
                eg += dp[0] + dp[1] + dp[2] + dp[6];
                eg -= dp[4];
                break;
            case 21:
                eg += dp[0] + dp[1] + dp[2] + dp[3] + dp[6];
                break;
            case 22: // notional - player blackjack
                eg += 1.5;
                break;
            case 23: // notional - player bust
                eg -= 1;
                break;
            default: // player has less than 17
                eg += dp[6];
                eg -= (1 - dp[6]);
        }
        return eg;
    }

    static double[] stand(int card1, int card2) {
        Deck deck = new Deck();
        deck.cards[card1]--;
        deck.cards[card2]--;
        deck.cards[0] = 50;

        int pscore = card1 + card2;
        if (card1 == 1 || card2 == 1) {
            pscore += 10;
        }

        double[] egs = new double[10];
        for (int uc = 1; uc <= 10; uc++) {
            Deck deck2 = new Deck(deck);
            deck2.cards[uc]--;
            deck2.cards[0]--;
            double[] dp = dealerProbs(uc, deck2);
            double eg = calcGain(pscore, dp);
            egs[uc > 1 ? uc - 2 : 9] = eg;
        }
        return egs;
    }

    static double[] hit(int card1, int card2, boolean once) {
        Deck deck = new Deck();
        deck.cards[card1]--;
        deck.cards[card2]--;
        deck.cards[0] = 50;

        double[] egs = new double[10];
        for (int uc = 1; uc <= 10; uc++) {
            Deck deck2 = new Deck(deck);
            deck2.cards[uc]--;
            deck2.cards[0] = 49;

            double peg = once ? playerGain(card1, card2, uc, deck2)
                             : playerGain2(card1, card2, uc, deck2);
            egs[uc > 1 ? uc - 2 : 9] = peg;
        }
        return egs;
    }

    static double[] doubleDown(int card1, int card2) {
        double[] egs = hit(card1, card2, true);
        for (int i = 0; i < 10; i++) {
            egs[i] *= 2;
        }
        return egs;
    }

    static double[] split(int card) {
        Deck deck = new Deck();
        deck.cards[card] -= 2;
        deck.cards[0] = 50;

        double[] egs = new double[10];
        int score = card;
        int eleven = 0;
        if (card == 1) {
            score = 11;
            eleven = 1;
        }

        for (int uc = 1; uc <= 10; uc++) {
            if (deck.cards[uc] == 0) continue;

            Deck deck2 = new Deck(deck);
            deck2.cards[uc]--;
            deck2.cards[0]--;
            int ix = uc > 1 ? uc - 2 : 9;

            double peg = 0.0;
            for (int c = 1; c <= 10; c++) {
                if (deck2.cards[c] == 0) continue;

                double prob = (double)deck2.cards[c] / deck2.cards[0];
                Deck deck3 = new Deck(deck2);
                deck3.cards[c]--;
                deck3.cards[0]--;

                int score2 = score + c;
                int eleven2 = eleven;
                if (c == 1) {
                    score2 += 10;
                    eleven2++;
                }

                if (score2 == 21) {
                    peg += 1.5 * prob;
                    continue;
                }

                if (score2 > 21 && eleven2 > 0) {
                    score2 -= 10;
                    eleven2--;
                }

                String action;
                if (eleven2 > 0) {
                    action = sTable2[score2 - 12][ix];
                } else {
                    action = hTable2[score2 - 4][ix];
                }

                double peg2;
                if (action.equals("S")) {
                    double[] dp = dealerProbs(uc, deck3);
                    peg2 = calcGain(score2, dp);
                } else {
                    peg2 = playerGain2(card, c, uc, deck3);
                }
                peg += peg2 * prob;
            }
            egs[ix] = peg * 2;
        }
        return egs;
    }

    static String bestAction(ActionGain[] ags) {
        double max = ags[0].gain;
        int maxi = 0;
        for (int i = 1; i < ags.length; i++) {
            if (ags[i].gain > max) {
                max = ags[i].gain;
                maxi = i;
            }
        }
        return ags[maxi].action;
    }

    static void printHeader(String title) {
        System.out.println(title);
        System.out.println("P/D     2      3      4      5      6      7      8      9      T      A");
        System.out.println("--------------------------------------------------------------------------");
    }

    static void printPair(int c) {
        if (c == 1) {
            System.out.print("AA   ");
        } else if (c == 10) {
            System.out.print("TT   ");
        } else {
            System.out.printf("%d%d   ", c, c);
        }
    }

    static void simulate(int perDay, int days) {
        int winDays = 0, loseDays = 0, evenDays = 0;
        double bigWin = 0.0, bigLoss = 0.0;
        double totalGain = 0.0, totalStake = 0.0;

        for (int d = 1; d <= days; d++) {
            double dailyGain = 0.0, dailyStake = 0.0;
            for (int p = 1; p <= perDay; p++) {
                double[] result = playerPlay();
                dailyGain += result[0];
                dailyStake += result[1];
            }

            if (dailyGain > 0) winDays++;
            else if (dailyGain < 0) loseDays++;
            else evenDays++;

            if (dailyGain > bigWin) bigWin = dailyGain;
            else if (-dailyGain > bigLoss) bigLoss = -dailyGain;

            totalGain += dailyGain;
            totalStake += dailyStake;
        }

        System.out.printf("%nAfter playing %d times a day for %d days:%n", perDay, days);
        System.out.println("Winning days   : " + winDays);
        System.out.println("Losing days    : " + loseDays);
        System.out.println("Breakeven days : " + evenDays);
        System.out.println("Biggest win    : " + bigWin);
        System.out.println("Biggest loss   : " + bigLoss);

        if (totalGain < 0) {
            System.out.println("Total loss     : " + (-totalGain));
            System.out.println("Total staked   : " + totalStake);
            System.out.printf("Loss %% staked  : %.3f%n", -totalGain / totalStake * 100);
        } else {
            System.out.println("Total win      : " + totalGain);
            System.out.println("Total staked   : " + totalStake);
            System.out.printf("Win %% staked   : %.3f%n", totalGain / totalStake * 100);
        }
    }

    static double dealerPlay(int pscore, int[] next, int[] cards, int[] d) {
        int dscore = d[0] + d[1];
        int aces = 0;
        if (d[0] == 1 || d[1] == 1) {
            dscore += 10;
            aces++;
        }

        while (true) {
            if (dscore > 21 && aces > 0) {
                dscore -= 10;
                aces--;
            }
            if (dscore > 21) return 1;
            if (dscore >= 17) {
                if (dscore > pscore) return -1;
                else if (dscore == pscore) break;
                else return 1;
            }
            int nc = cards[next[0]++];
            dscore += nc;
            if (nc == 1) {
                dscore += 10;
                aces++;
            }
        }
        return 0;
    }

    static double[] playerPlay() {
        List<Integer> perm = new ArrayList<>();
        for (int i = 0; i < 52; i++) perm.add(i);
        Collections.shuffle(perm, random);

        int[] cards = new int[52];
        for (int i = 0; i < 52; i++) {
            int card = perm.get(i) / 4 + 1;
            if (card > 10) card = 10;
            cards[i] = card;
        }

        int[] p = new int[2];
        int[] d = new int[2];
        p[0] = cards[0]; p[1] = cards[1];
        d[0] = cards[2]; d[1] = cards[3];
        int[] next = {4};

        boolean dbj = (d[0] == 1 && d[1] == 10) || (d[0] == 10 && d[1] == 1);
        boolean pbj = (p[0] == 1 && p[1] == 10) || (p[0] == 10 && p[1] == 1);

        if (dbj) return pbj ? new double[]{0.0, 1.0} : new double[]{-1.0, 1.0};
        if (pbj) return new double[]{1.5, 1.0};

        int uc = d[0] == 1 ? 9 : d[0] - 1;
        double stake = 1.0;
        int[] fscores = new int[2];

        int score = p[0] + p[1];
        String kind = (p[0] == p[1]) ? "pair" :
                     ((p[0] == 1 || p[1] == 1) ? "soft" : "hard");

        int[] aces = {0};
        String[] action = {""};
        int[] scoreArr = {score};

        switch (kind) {
            case "hard":
                action[0] = hTable[score - 5][uc];
                break;
            case "soft":
                int otherCard = p[0] == 1 ? p[1] : p[0];
                scoreArr[0] += 10;
                aces[0] = 1;
                action[0] = sTable[otherCard - 2][uc];
                break;
            case "pair":
                if (p[0] == 1) {
                    scoreArr[0] += 10;
                    aces[0] = 2;
                }
                action[0] = pTable[p[0] - 1][uc];
                break;
        }

        if (action[0].equals("S")) {
            fscores[0] = scoreArr[0];
        } else if (action[0].equals("H")) {
            hit(0, fscores, scoreArr, aces, action, next, cards, uc);
        } else if (action[0].equals("D")) {
            hit(0, fscores, scoreArr, aces, action, next, cards, uc);
            stake = 2;
        } else if (action[0].equals("P")) {
            for (int hand = 0; hand < 2; hand++) {
                scoreArr[0] = p[0];
                aces[0] = 0;
                if (scoreArr[0] == 1) {
                    scoreArr[0] = 11;
                    aces[0]++;
                }
                hit(hand, fscores, scoreArr, aces, action, next, cards, uc);
            }
        }

        double sum = 0.0;
        if (fscores[0] < 22) {
            sum += dealerPlay(fscores[0], next, cards, d) * stake;
        } else {
            sum -= 1 * stake;
        }

        if (fscores[1] > 0) {
            if (fscores[1] < 22) {
                sum += dealerPlay(fscores[1], next, cards, d);
            } else {
                sum -= 1;
            }
            stake = 2;
        }

        return new double[]{sum, stake};
    }

    static void hit(int hand, int[] fscores, int[] scoreArr, int[] aces,
                   String[] action, int[] next, int[] cards, int uc) {
        while (true) {
            int nc = cards[next[0]++];
            scoreArr[0] += nc;
            if (nc == 1) {
                scoreArr[0] += 10;
                aces[0]++;
            }
            if (scoreArr[0] > 21 && aces[0] > 0) {
                scoreArr[0] -= 10;
                aces[0]--;
            }
            if (scoreArr[0] > 21) {
                fscores[hand] = 22;
                return;
            }
            if (action[0].equals("D")) {
                fscores[hand] = scoreArr[0];
                return;
            }

            if (aces[0] == 0) {
                action[0] = hTable2[scoreArr[0] - 4][uc];
            } else {
                action[0] = sTable2[scoreArr[0] - 12][uc];
            }

            if (action[0].equals("S")) {
                fscores[hand] = scoreArr[0];
                return;
            }
        }
    }

    public static void main(String[] args) {
        dealerChart();

        // Hard scores
        int[][] tuples = {
            {2,3}, {2,4}, {2,5}, {3,4}, {2,6}, {3,5}, {2,7}, {3,6}, {4,5},
            {2,8}, {3,7}, {4,6}, {2,9}, {3,8}, {4,7}, {5,6},
            {2,10}, {3,9}, {4,8}, {5,7}, {3,10}, {4,9}, {5,8}, {6,7},
            {4,10}, {5,9}, {6,8}, {5,10}, {6,9}, {7,8},
            {6,10}, {7,9}, {7,10}, {8,9}, {8,10}, {9,10}
        };

        double[] counts = {1,1,2,2,3,3,4,4,4,3,3,2,2,1,1};
        double[][] segs = new double[15][10];
        double[][] hegs = new double[15][10];
        double[][] degs = new double[15][10];

        for (int[] tuple : tuples) {
            int i = tuple[0] + tuple[1];
            double[] sg = stand(tuple[0], tuple[1]);
            double[] hg = hit(tuple[0], tuple[1], false);
            double[] dg = doubleDown(tuple[0], tuple[1]);
            for (int j = 0; j < 10; j++) {
                segs[i-5][j] += sg[j];
                hegs[i-5][j] += hg[j];
                degs[i-5][j] += dg[j];
            }
        }

        for (int i = 0; i < 15; i++) {
            for (int j = 0; j < 10; j++) {
                segs[i][j] /= counts[i];
                hegs[i][j] /= counts[i];
                degs[i][j] /= counts[i];
            }
        }

        printHeader("\nHard Chart - Player Expected Gains per unit (Stand)");
        for (int i = 5; i < 20; i++) {
            System.out.printf("%2d   ", i);
            for (int j = 0; j < 10; j++) {
                System.out.printf("%.3f ", segs[i-5][j]);
            }
            System.out.println();
        }

        printHeader("\nHard Chart - Player Expected Gains per unit (Hit)");
        for (int i = 5; i < 20; i++) {
            System.out.printf("%2d   ", i);
            for (int j = 0; j < 10; j++) {
                System.out.printf("%.3f ", hegs[i-5][j]);
            }
            System.out.println();
        }

        printHeader("\nHard Chart - Player Expected Gains per original unit (Double)");
        for (int i = 5; i < 20; i++) {
            System.out.printf("%2d   ", i);
            for (int j = 0; j < 10; j++) {
                System.out.printf("%.3f ", degs[i-5][j]);
            }
            System.out.println();
        }

        printHeader("\nHard Chart - Player Strategy (Round 1)");
        for (int i = 5; i < 20; i++) {
            System.out.printf("%2d   ", i);
            for (int j = 0; j < 10; j++) {
                ActionGain[] ags = {
                    new ActionGain("S", segs[i-5][j]),
                    new ActionGain("H", hegs[i-5][j]),
                    new ActionGain("D", degs[i-5][j])
                };
                String action = bestAction(ags);
                hTable[i-5][j] = action;
                System.out.printf("%4s   ", action);
            }
            System.out.println();
        }

        // Hard Round >= 2
        double[][] segs2 = new double[18][10];
        double[][] hegs2 = new double[18][10];

        for (int i = 5; i < 20; i++) {
            segs2[i-4] = segs[i-5];
            hegs2[i-4] = hegs[i-5];
        }

        double[] sg4 = stand(2, 2);
        double[] hg4 = hit(2, 2, false);
        double[] sg20 = stand(10, 10);
        double[] hg20 = hit(10, 10, false);
        double[] sg21 = stand(1, 10);
        double[] hg21 = hit(1, 10, false);

        for (int j = 0; j < 10; j++) {
            segs2[0][j] = sg4[j];
            hegs2[0][j] = hg4[j];
            segs2[16][j] = sg20[j];
            hegs2[16][j] = hg20[j];
            segs2[17][j] = sg21[j];
            hegs2[17][j] = hg21[j];
        }

        printHeader("\nHard Chart - Player Strategy (Round >= 2, No Doubling)");
        for (int i = 4; i < 22; i++) {
            System.out.printf("%2d   ", i);
            for (int j = 0; j < 10; j++) {
                String action = hegs2[i-4][j] > segs2[i-4][j] ? "H" : "S";
                hTable2[i-4][j] = action;
                System.out.printf("%4s   ", action);
            }
            System.out.println();
        }

        // Soft scores
        double[][] segs3 = new double[8][10];
        double[][] hegs3 = new double[8][10];
        double[][] degs3 = new double[8][10];

        for (int c = 2; c < 10; c++) {
            double[] sg = stand(1, c);
            double[] hg = hit(1, c, false);
            double[] dg = doubleDown(1, c);
            for (int j = 0; j < 10; j++) {
                segs3[c-2][j] = sg[j];
                hegs3[c-2][j] = hg[j];
                degs3[c-2][j] = dg[j];
            }
        }

        printHeader("\nSoft Chart - Player Expected Gains per unit (Stand)");
        for (int c = 2; c < 10; c++) {
            System.out.printf("A%d   ", c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("%.3f ", segs3[c-2][j]);
            }
            System.out.println();
        }

        printHeader("\nSoft Chart - Player Expected Gains per unit (Hit)");
        for (int c = 2; c < 10; c++) {
            System.out.printf("A%d   ", c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("%.3f ", hegs3[c-2][j]);
            }
            System.out.println();
        }

        printHeader("\nSoft Chart - Player Expected Gains per original unit (Double)");
        for (int c = 2; c < 10; c++) {
            System.out.printf("A%d   ", c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("%.3f ", degs3[c-2][j]);
            }
            System.out.println();
        }

        printHeader("\nSoft Chart - Player Strategy (Round 1)");
        for (int c = 2; c < 10; c++) {
            System.out.printf("A%d   ", c);
            for (int j = 0; j < 10; j++) {
                ActionGain[] ags = {
                    new ActionGain("S", segs3[c-2][j]),
                    new ActionGain("H", hegs3[c-2][j]),
                    new ActionGain("D", degs3[c-2][j])
                };
                String action = bestAction(ags);
                sTable[c-2][j] = action;
                System.out.printf("%4s   ", action);
            }
            System.out.println();
        }

        // Soft Round >= 2
        double[][] segs4 = new double[10][10];
        double[][] hegs4 = new double[10][10];

        for (int i = 1; i < 9; i++) {
            segs4[i] = segs3[i-1];
            hegs4[i] = hegs3[i-1];
        }

        double[] sg12 = stand(1, 1);
        double[] hg12 = hit(1, 1, false);

        for (int j = 0; j < 10; j++) {
            segs4[0][j] = sg12[j];
            hegs4[0][j] = hg12[j];
            segs4[9][j] = sg21[j];
            hegs4[9][j] = hg21[j];
        }

        printHeader("\nSoft Chart - Player Strategy (Round >= 2, No Doubling)");
        for (int i = 12; i < 22; i++) {
            System.out.printf("%2d   ", i);
            for (int j = 0; j < 10; j++) {
                String action = hegs4[i-12][j] > segs4[i-12][j] ? "H" : "S";
                sTable2[i-12][j] = action;
                System.out.printf("%4s   ", action);
            }
            System.out.println();
        }

        // Pairs
        double[][] segs5 = new double[10][10];
        double[][] hegs5 = new double[10][10];
        double[][] degs5 = new double[10][10];
        double[][] pegs5 = new double[10][10];

        for (int c = 1; c <= 10; c++) {
            double[] sg = stand(c, c);
            double[] hg = hit(c, c, false);
            double[] dg = doubleDown(c, c);
            double[] pg = split(c);
            for (int j = 0; j < 10; j++) {
                segs5[c-1][j] = sg[j];
                hegs5[c-1][j] = hg[j];
                degs5[c-1][j] = dg[j];
                pegs5[c-1][j] = pg[j];
            }
        }

        printHeader("\nPairs Chart - Player Expected Gains per unit (Stand)");
        for (int c = 1; c <= 10; c++) {
            printPair(c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("% 0.3f ", segs5[c-1][j]);
            }
            System.out.println();
        }

        printHeader("\nPairs Chart - Player Expected Gains per unit (Hit)");
        for (int c = 1; c <= 10; c++) {
            printPair(c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("% 0.3f ", hegs5[c-1][j]);
            }
            System.out.println();
        }

        printHeader("\nPairs Chart - Player Expected Gains per original unit (Double)");
        for (int c = 1; c <= 10; c++) {
            printPair(c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("% 0.3f ", degs5[c-1][j]);
            }
            System.out.println();
        }

        printHeader("\nPairs Chart - Player Expected Gains per original unit (Split)");
        for (int c = 1; c <= 10; c++) {
            printPair(c);
            for (int j = 0; j < 10; j++) {
                System.out.printf("% 0.3f ", pegs5[c-1][j]);
            }
            System.out.println();
        }

        printHeader("\nPairs Chart - Player Strategy (Round 1)");
        for (int c = 1; c <= 10; c++) {
            printPair(c);
            for (int j = 0; j < 10; j++) {
                ActionGain[] ags = {
                    new ActionGain("S", segs5[c-1][j]),
                    new ActionGain("H", hegs5[c-1][j]),
                    new ActionGain("D", degs5[c-1][j]),
                    new ActionGain("P", pegs5[c-1][j])
                };
                String action = bestAction(ags);
                pTable[c-1][j] = action;
                System.out.printf("%4s   ", action);
            }
            System.out.println();
        }

        // Simulations
        random.setSeed(System.currentTimeMillis());
        for (int i = 1; i <= 10; i++) {
            System.out.printf("%nSimulation for Year %d:%n", i);
            simulate(50, 365);
        }
    }
}
