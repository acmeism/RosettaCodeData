/* TypeScript code for dealing Microsoft FreeCell / FreeCell Pro deals.
 * Copyright by Shlomi Fish, 2011.
 * Released under the MIT/Expat License
 * ( http://en.wikipedia.org/wiki/MIT_License ).
 */
function perl_range(start: number, end: number): number[] {
    const ret: number[] = [];

    for (let i = start; i <= end; ++i) {
        ret.push(i);
    }

    return ret;
}

// 33 bit
const MAX_SEED: bigint = (BigInt(1) << BigInt(31 + 2)) - BigInt(1);
const X = BigInt(1) << BigInt(32);

/*
 * Microsoft C Run-time-Library-compatible Random Number Generator
 * */
class MSRand {
    private gamenumber: string;
    private _seed: bigint;
    private _seedx: bigint;
    constructor(args) {
        const that = this;
        that.gamenumber = args.gamenumber;
        const _seed = BigInt(that.gamenumber);
        that._seed = _seed;
        that._seedx = _seed < X ? _seed : _seed - X;
        return;
    }
    public getSeed(): bigint {
        const that = this;
        return that._seed;
    }
    private setSeed(seed: bigint): void {
        const that = this;
        that._seed = seed;
        return;
    }

    private _rando(): bigint {
        const that = this;
        that._seedx =
            (that._seedx * BigInt(214013) + BigInt(2531011)) & MAX_SEED;
        return (that._seedx >> BigInt(16)) & BigInt(0x7fff);
    }
    private _randp(): bigint {
        const that = this;
        that._seedx =
            (that._seedx * BigInt(214013) + BigInt(2531011)) & MAX_SEED;
        return (that._seedx >> BigInt(16)) & BigInt(0xffff);
    }
    public raw_rand(): bigint {
        const that = this;

        if (that._seed < X) {
            const ret = that._rando();
            return that._seed < BigInt(0x8) << BigInt(28)
                ? ret
                : ret | BigInt(0x8000);
        } else {
            return that._randp() + BigInt(1);
        }
    }
    public max_rand(mymax: bigint): bigint {
        const that = this;
        return that.raw_rand() % mymax;
    }
    public shuffle(deck: Array<any>): Array<any> {
        const that = this;
        if (deck.length) {
            let i = deck.length;
            while (--i) {
                const j = Number(that.max_rand(BigInt(i + 1)));
                const tmp = deck[i];
                deck[i] = deck[j];
                deck[j] = tmp;
            }
        }
        return deck;
    }
}
/*
 * Microsoft Windows Freecell / Freecell Pro boards generation.
 *
 * See:
 *
 * - http://rosettacode.org/wiki/Deal_cards_for_FreeCell
 *
 * - http://www.solitairelaboratory.com/mshuffle.txt
 *
 * Under MIT/Expat Licence.
 *
 * */

export function deal_ms_fc_board(gamenumber: string): string {
    const randomizer = new MSRand({
        gamenumber: gamenumber,
    });
    const num_cols: number = 8;

    const columns: Array<Array<number>> = perl_range(0, num_cols - 1).map(
        () => {
            return [];
        },
    );
    let deck: Array<number> = perl_range(0, 4 * 13 - 1);

    randomizer.shuffle(deck);

    deck = deck.reverse();

    for (let i = 0; i < 52; ++i) {
        columns[i % num_cols].push(deck[i]);
    }

    function render_card(card: number): String {
        const suit = card % 4;
        const rank = Math.floor(card / 4);

        return "A23456789TJQK".charAt(rank) + "CDHS".charAt(suit);
    }

    function render_column(col: Array<number>): String {
        return ": " + col.map(render_card).join(" ") + "\n";
    }

    return columns.map(render_column).join("");
}
