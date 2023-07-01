public class OldLadySwallowedAFly {

    final static String[] data = {
        "_ha _c _e _p,/Quite absurd_f_p;_`cat,/Fancy that_fcat;_j`dog,/What a hog"
        + "_fdog;_l`pig,/Her mouth_qso big_fpig;_d_r,/She just opened her throat_f_"
        + "r;_icow,/_mhow she_ga cow;_k_o,/It_qrather wonky_f_o;_a_o_bcow,_khorse.."
        + "./She's dead, of course!/", "_a_p_b_e ", "/S_t ", " to catch the ", "fly,/Bu"
        + "t _mwhy s_t fly,/Perhaps she'll die!//_ha", "_apig_bdog,_l`", "spider,/Tha"
        + "t wr_nj_ntickled inside her;_aspider_b_c", ", to_s a ", "_sed ", "There_qan"
        + " old lady who_g", "_a_r_bpig,_d", "_acat_b_p,_", "_acow_b_r,_i", "_adog_bcat"
        + ",_j", "I don't know ", "iggled and ", "donkey", "bird", " was ", "goat", " swal"
        + "low", "he_gthe"};

    static boolean oldLady(String part, boolean s) {
        for (char c : part.toCharArray()) {
            if (s)
                s = oldLady(data[c - '_'], false);
            else if (c == '_')
                s = true;
            else
                System.out.print(c == '/' ? '\n' : c);
        }
        return s;
    }

    public static void main(String[] args) {
        oldLady(data[0], false);
    }
}
