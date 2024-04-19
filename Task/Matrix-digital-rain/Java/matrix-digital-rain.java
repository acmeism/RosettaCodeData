import java.awt.Canvas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.image.BufferStrategy;
import java.awt.image.BufferedImage;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.swing.JFrame;

public final class MatrixDigitalRain {

    public static void main(String[] args) {
    	EventQueue.invokeLater( () -> {
    		 JFrame.setDefaultLookAndFeelDecorated(true);
             JFrame frame = new JFrame("Matrix Digital Rain");
             frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
             frame.setResizable(false);
             DigitalRain digitalRain = new DigitalRain(800, 600);
             frame.add(digitalRain);
             frame.setLocationByPlatform(true);
             frame.pack();
             frame.setVisible(true);

             digitalRain.start();
    	} );
    }

    private static final class DigitalRain extends Canvas {

        public DigitalRain(int aWidth, int aHeight) {    		    				
    		setPreferredSize( new Dimension(aWidth, aHeight) );
    		setBackground(Color.BLACK);	
    		
    		columnCount = aWidth / ( 2 * halfColumnWidth ) - 1;
    		rowCount = aHeight / ( 2 * halfFontSize );
    		
    		setCursor(getToolkit().createCustomCursor(
                new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB), new Point(0, 0), "transparent"));   		
    		
    		executiveService = Executors.newSingleThreadExecutor();
    		random = ThreadLocalRandom.current();
        }

        public void start() {
        	requestFocus();
            createBufferStrategy(2);
            executiveService.execute( new DrawingCycle(rowCount) );
        }

        private final class DrawingCycle implements Runnable {
        	
        	public DrawingCycle(int rowCount) {
        		columns = Stream.generate( () -> new Column(rowCount) )
        				        .limit(columnCount).collect(Collectors.toList());        		
        		bufferStrategy = getBufferStrategy();
        		scheduler = Executors.newSingleThreadScheduledExecutor();
        	}

            @Override
            public void run() {
            	scheduler.scheduleAtFixedRate( () -> { draw(); update(); }, 0, 100, TimeUnit.MILLISECONDS);
            }

            private void draw() {
                Graphics2D graphics2D = (Graphics2D) bufferStrategy.getDrawGraphics();           	
            	graphics2D.setColor(Color.BLACK);
            	graphics2D.fillRect(0, 0, getWidth(), getHeight());         	
            	
            	for (  int col = 0; col < columnCount; col++ ) {
            		for ( int row = 0; row < rowCount; row++ ) {
        				Symbol symbol = columns.get(col).symbols.get(row);
        				graphics2D.setFont(symbol.font);
    					graphics2D.setColor(symbol.color());
    					final int size = symbol.font.getSize();
    					graphics2D.drawString(
    							symbol.element,
    							2 * halfColumnWidth * col + halfColumnWidth + ( 6 * halfFontSize - size ) / 2,
    							row * 2 * halfFontSize);
                 	}
            	}

        		graphics2D.dispose();
                bufferStrategy.show();
            }

            private void update() {
            	for ( Column column : columns ) {       		
            		if ( column.index >= 0 ) {
            			String element = elements.get(random.nextInt(elements.size()));
            			column.symbols.set(column.index, new Symbol(element, column.font, 255) );
            		}
            		
            		column.index = Math.min(column.index + 1, rowCount);
                	column.darken();

                	if ( column.index == rowCount ) {
                		column.reset();
                	}
            	}     	
            }

            private final List<Column> columns;
            private final BufferStrategy bufferStrategy;
            private final ScheduledExecutorService scheduler;

        } // End DrawingCycle class

        private final class Column {
        	
        	public Column(int aRowCount) {
        		rowCount = aRowCount;    		
        		index = random.nextInt(-rowCount, rowCount);
        		setFont();
    			symbols = Stream.generate( () -> new Symbol(font) ).limit(rowCount).collect(Collectors.toList());
    			
    		}
        	
    	    public void darken() {
    	    	symbols.stream().forEach(Symbol::darken);
    	    }
    	
    	    public void reset() {
    			index = random.nextInt(-rowCount, rowCount / 2);
    			setFont();
    	    }
    	
    	    private void setFont() {
    	    	final int fontSize = ( random.nextInt(2) == 0 ) ?
    	    		2 * halfFontSize : ( random.nextInt(2) == 0 ) ?
    	    			(int) ( 1.5 * halfFontSize ) : 3 * halfFontSize;
        		final int fontStyle = ( random.nextInt(3) == 0 ) ? Font.BOLD : Font.PLAIN;
        		font = new Font("Dialog", fontStyle, fontSize);
    	    }
    	
    	    private int index;
    	    private Font font;
    	    private List<Symbol> symbols;
    	
    	    private final int rowCount;	
        	
        } // End Column class

        private final class Symbol {
        	
        	public Symbol(String aElement, Font aFont, int aBrightness) {
        		element = aElement;
        		font = aFont;
        		brightness = aBrightness;
        	}
        	
        	public Symbol(Font font) {
        		this(" ", font, 0);
        	}
        	
        	public Color color() {
    			return new Color(0, 255, 0, brightness);
    		}
    		
    	    public void darken() {
    	    	brightness = Math.max(0, brightness - 5);
    	    }
    	
    	    public String toString() {
    	    	return element;
    	    }
    	
    	    private int brightness;
        	
    	    private final Font font;
        	private final String element;    	
        	
        } // End Symbol class

    	private final int columnCount;
    	private final int rowCount;    	
    	private final ExecutorService executiveService;    	
    	private final int halfFontSize = 6;
    	private final int halfColumnWidth = 10;
    	private final ThreadLocalRandom random;
	    private final List<String> elements = List.of(
			"M", "Ї", "Љ", "Њ", "Ћ", "Ќ", "Ѝ", "Ў", "Џ", "Б", "Г", "Д", "Ж", "И", "Й", "Л", "П", "Ф", "Ц", "Ч", "Ш",
			"Щ", "Ъ", "Ы", "Э", "Ю", "Я", "в", "д", "ж", "з", "и", "й", "к", "л", "м", "н", "п", "т", "ф", "ц", "ч",
			"ш", "щ", "ъ", "ы", "ь", "э", "ю", "я", "ѐ", "ё", "ђ", "ѓ", "є", "ї", "љ", "њ", "ћ", "ќ", "ѝ", "ў", "џ",
	        "Ѣ", "ѣ", "ѧ", "Ѯ", "ѱ", "Ѳ", "ѳ", "ҋ", "Ҍ", "ҍ", "Ҏ", "ҏ", "Ґ", "ґ", "Ғ", "ғ", "Ҕ", "ҕ", "Җ", "җ", "Ҙ",
	        "ҙ", "Қ", "қ", "ҝ", "ҟ", "ҡ", "Ң", "ң", "Ҥ", "ҥ", "ҩ", "Ҫ", "ҫ", "Ҭ", "ҭ", "Ұ", "ұ", "Ҳ", "ҳ", "ҵ", "ҷ",
	        "ҹ", "Һ", "ҿ", "Ӂ", "ӂ", "Ӄ", "ӄ", "ӆ", "Ӈ", "ӈ", "ӊ", "Ӌ", "ӌ", "ӎ", "Ӑ", "ӑ", "Ӓ", "ӓ", "Ӕ", "ӕ", "Ӗ",
	        "ӗ", "Ә", "ә", "Ӛ", "ӛ", "Ӝ", "ӝ", "Ӟ", "ӟ", "ӡ", "Ӣ", "ӣ", "Ӥ", "ӥ", "Ӧ", "ӧ", "Ө", "ө", "Ӫ", "ӫ", "Ӭ",
	        "ӭ", "Ӯ", "ӯ", "Ӱ", "ӱ", "Ӳ", "ӳ", "Ӵ", "ӵ", "Ӷ", "ӷ", "Ӹ", "ӹ", "Ӻ", "ӽ", "ӿ", "Ԁ", "ԍ", "ԏ", "Ԑ", "ԑ",
	        "ԓ", "Ԛ", "ԟ", "Ԧ", "ԧ", "Ϥ", "ϥ", "ϫ", "ϭ", "ｩ", "ｪ", "ｫ", "ｬ", "ｭ", "ｮ", "ｯ", "ｰ", "ｱ", "ｲ", "ｳ", "ｴ",
	        "ｵ", "ｶ", "ｷ", "ｸ", "ｹ", "ｺ", "ｻ", "ｼ", "ｽ", "ｾ", "ｿ", "ﾀ", "ﾁ", "ﾂ", "ﾃ", "ﾄ", "ﾅ", "ﾆ", "ﾇ", "ﾈ", "ﾉ",
	        "ﾊ", "ﾋ", "ﾌ", "ﾍ", "ﾎ", "ﾏ", "ﾐ", "ﾑ", "ﾒ", "ﾓ", "ﾔ", "ﾕ", "ﾖ", "ﾗ", "ﾘ", "ﾙ", "ﾚ", "ﾛ", "ﾜ", "ﾝ", "ⲁ",
	        "Ⲃ", "ⲃ", "Ⲅ", "Γ", "Δ", "Θ", "Λ", "Ξ", "Π", "Ѐ", "Ё", "Ђ", "Ѓ", "Є", "ⲉ", "Ⲋ", "ⲋ", "Ⲍ", "ⲍ", "ⲏ", "ⲑ",
	        "ⲓ", "ⲕ", "ⲗ", "ⲙ", "ⲛ", "Ⲝ", "ⲝ", "ⲡ", "ⲧ", "ⲩ", "ⲫ", "ⲭ", "ⲯ", "ⳁ", "Ⳉ", "ⳉ", "ⳋ", "ⳤ", "⳥", "⳦", "⳨",
	        "⳩", "∀", "∁", "∂", "∃", "∄", "∅", "∆", "∇", "∈", "∉", "∊", "∋", "∌", "∍", "∎", "∏", "∐", "∑", "∓",
	        "ℇ", "ℏ", "℥", "Ⅎ", "ℷ", "⩫", "⨀", "⨅", "⨆", "⨉", "⨍", "⨎", "⨏", "⨐", "⨑", "⨒", "⨓", "⨔", "⨕", "⨖",
	        "⨗", "⨘", "⨙", "⨚", "⨛", "⨜", "⨝", "⨿", "⩪" );	

    } // End DigitalRain class

} // End MatrixDigitalRain class
