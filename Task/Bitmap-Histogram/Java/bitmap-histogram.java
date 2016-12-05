package bitmap;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
* Image processing functions such as histogram, grayscale,..
* here we assume we  have a YUV image. so we process only luma component Y
* the histogram can be called on luma pixel only (values from 0 to 255)
* greyscale is done with a constant middle value of FullRange / 2 = 127
*/
public class ImageProc {

    static final private Integer MAX_VAL = 255;
    static final private Integer MIN_VAL = 0;
    static final private Integer MID_RANGE = (MAX_VAL - MIN_VAL) >> 1;

    private static Integer[] lumaHist(Integer[] luma,Integer length) {
        // from input length, select a number of classes (intervalles )
        // usually take sqrt(length)
            if ((length == 0 )|| (luma == null)){
                return null;
            }
            double stepd = Math.sqrt(length);
            // define the interval width
            int step = (int)stepd ;
            Integer width = (int)(length / stepd);
            // define step Lists containing only values in one interval
            // done with a loop generating a new list that discard lower part
            // the luma buff is fist sorted to split the array correctly
            // only values greater than width are kept in a new list

            List<Integer> interv[] = new ArrayList[step];
            Integer hist[] = new Integer[step];
            interv[0] = Arrays.stream(luma)
                                .parallel()
                                .sorted()
                                .filter(value -> value >= width)
                                .collect(Collectors.toList());
            hist[0] = length - interv[0].size();

            // here due to a lambda expression limitation
            // we can not modify the width value. (should be a final var)
            // so we decrease each reaming values with width, and store in a new list
            // the filter is than the same across iterations
            // histogram is computed in the same loop: the number of data for the interval
            // is equal to the previous list size minus the new list size
            for (int i =1; i < step; i++){

                interv[i] = interv[i-1].stream()
                                     .map(value -> value -= width)
                                     .filter(value -> value >= width)
                                     .collect(Collectors.toList());
                hist[i] = interv[i-1].size() - interv[i].size();
          }

            return hist;
	}

        private static Integer[] blackAndWhite(Integer[] luma,Integer length) {

            List<Integer>  bwPict ;
            // compute the average value of the stream
            // need to transform the List<Integer> in List<String> to transform in int !!!

           double average;
            average = Stream.of(luma).map(i -> i.toString())
                                     .mapToInt(Integer::parseInt)
                                     .average()
                                     .getAsDouble();
           System.out.println("Average value : "  +average);
           // compare each value with the average
           // if less set to 0 (black) if more, set to 255 (black)
            bwPict= Arrays.stream(luma)
                          .parallel()
                          .map(value -> (value > average) ?MAX_VAL: MIN_VAL)
                          .collect(Collectors.toList());

            Integer retPict[] = new Integer[bwPict.size()];
            return bwPict.toArray(retPict);
        }

	public static void main (String[] args)
	{
            Integer[] histo;
            Integer img_y[] = new Integer[256];
            // generate ramdom values just for testing algo
            Random r = new Random();
            for (int i=0;i< img_y.length; i++) {
                img_y[i] = r.nextInt(MAX_VAL);
            }

           // *********  compute histogram   ********************
            histo = lumaHist(img_y,img_y.length);

	    System.out.println("histogram size =:" + histo.length );
 	
            int sum = 0;
            for (int i=0; i< histo.length;i++) {
                System.out.println("histo[" + i + "] =:" + histo[i]);
                sum +=histo[i];
            }
            // check results are ok
            // first check nb of elments in histo is 256
            if (sum != img_y.length){
                System.out.println("Error in histogram processing!\n"
                                + "Numbers of value not coherent");
            }
            Integer hist[] = new Integer[16];
            Arrays.fill(hist, 0);
            for (int i=0;i< 256; i++) {
                if (img_y[i] < 16) hist[0]++;
                else if (img_y[i] < 32) hist[1]++;
                else if (img_y[i] < 48) hist[2]++;
                else if (img_y[i] < 64) hist[3]++;
                else if (img_y[i] < 80) hist[4]++;
                else if (img_y[i] < 96) hist[5]++;
                else if (img_y[i] < 112) hist[6]++;
                else if (img_y[i] < 128) hist[7]++;
                else if (img_y[i] < 144) hist[8]++;
                else if (img_y[i] < 160) hist[9]++;
                else if (img_y[i] < 176) hist[10]++;
                else if (img_y[i] < 192) hist[11]++;
                else if (img_y[i] < 208) hist[12]++;
                else if (img_y[i] < 224) hist[13]++;
                else if (img_y[i] < 240) hist[14]++;
                else  hist[15]++;

            }
            if (hist.length != histo.length) {
                System.out.println("Error in histogram processing!\n"
                                    + "histogram size is wrong ");
                return;
            }
            else {
                for (int i=0; i< histo.length;i++) {
                    if (!Objects.equals(hist[i], histo[i])) {
                        System.out.println("Error in histogram processing!\n"
                                    + "values are different (interv= " + i
                                    + " computed: " + histo[i]
                                    +  " theorical :" + hist[i] + "\n");
                        return;
                    }
                }
            }
            System.out.println("Test OK\n");

          // *********  compute grayscale image   ********************
            Integer pictBW[];
            pictBW = blackAndWhite(img_y,img_y.length);

             for (int i=0;i< img_y.length; i++) {
                 System.out.println("Original[" + i +"]:" + img_y[i] +
                                    " BandW[" + i +"]:" +pictBW[i] );
             }

	}
}
