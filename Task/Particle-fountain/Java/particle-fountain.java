import java.awt.Canvas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.image.BufferStrategy;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadLocalRandom;

import javax.swing.JFrame;

public final class ParticleFountainTask {

    public static void main(String[] args) {
    	EventQueue.invokeLater( () -> {
    		 JFrame.setDefaultLookAndFeelDecorated(true);
             JFrame frame = new JFrame("Particle Fountain");
             frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
             frame.setResizable(false);
             ParticleFountain particleFountain = new ParticleFountain(3_000, 1_000, 750);
             frame.add(particleFountain);
             frame.pack();
             frame.setLocationRelativeTo(null);
             frame.setVisible(true);

             particleFountain.start();
    	} );
    }

    private static final class ParticleFountain extends Canvas {

        public ParticleFountain(int aParticleCount, int aWidth, int aHeight) {
        	particleCount = aParticleCount;
    		width = aWidth;
    		height = aHeight;
    		saturation = 0.6;
    		spread = 1.5;
    		range = 1.5;
    		reciprocate = false;    		  		
    				
    		setPreferredSize( new Dimension(width, height) );
    		addKeyListener( new InputHandler() );    		
    		
    		executorService = Executors.newSingleThreadExecutor();
        }

        public void start() {
        	requestFocus();
            createBufferStrategy(2);
            executorService.execute( new DrawingCycle() );
        }

        private final class DrawingCycle implements Runnable {
        	
        	public DrawingCycle() {
        		positions = new double[2 * particleCount];
        		velocities = new double[2 * particleCount];
        	    lifetimes = new double[particleCount];
        	    points = new Point[particleCount];
        	    Arrays.fill(points, new Point(0, 0) );
        	
        	    random = ThreadLocalRandom.current();
        	}

            @Override
            public void run() {
                bufferStrategy = getBufferStrategy();

                while ( true ) {
                    update(0.005);
                    draw();
                }
            }

            private void update(double animationSpeed) {
            	int xIndex = 0;
        		int yIndex = 1;
        		pointIndex = 0;

        		for ( int index = 0; index < particleCount; index++ ) {
        		    boolean showParticle = false;
        		    if ( lifetimes[index] <= 0.0 ) {
        		        if ( random.nextDouble() < animationSpeed ) {
        			        lifetimes[index] = 2.5;
        			        positions[xIndex] = width / 20;
        			        positions[yIndex] = height / 10;
        			        velocities[xIndex] =
        			        	10 * ( spread * random.nextDouble() - spread / 2 + additionalXSpeed() );
        			        velocities[yIndex] = ( random.nextDouble() - 2.9 ) * height / 20.5;
        			        showParticle = true;
        		        }
        		    } else {
        		        if ( positions[yIndex] > height / 10 && velocities[yIndex] > 0 ) {
        		            velocities[yIndex] *= -0.3; // bounce particle
        		        }
        		
        		        velocities[yIndex] += animationSpeed * height / 10;
        		        positions[xIndex] += velocities[xIndex] * animationSpeed;
        		        positions[yIndex] += velocities[yIndex] * animationSpeed;
        		        lifetimes[index] -= animationSpeed;
        		        showParticle = true;
        		    }

        		    if ( showParticle ) {
        		        points[pointIndex] = new Point((int) ( positions[xIndex] * 10 ),
        		        		                       (int) ( positions[yIndex] * 10 ));
        		        pointIndex += 1;
        		    }
        		
        		    xIndex += 2;
        		    yIndex = xIndex + 1;
        		}
            }

            private void draw() {
                Graphics2D graphics2D = (Graphics2D) bufferStrategy.getDrawGraphics();
        		graphics2D.setColor(Color.BLACK);
        		graphics2D.fillRect(0, 0, getWidth(), getHeight());		
        		for ( int i = 0; i < pointIndex; i++ ) {
        			graphics2D.setColor(Color.getHSBColor(random.nextFloat(), (float) saturation, 1.0F));
        			graphics2D.fillOval(points[i].x, points[i].y, 5, 5);
        		}
        		graphics2D.dispose();

                bufferStrategy.show();
            }

            private double additionalXSpeed() {
        		return ( reciprocate ) ? range * Math.sin(System.currentTimeMillis() / 1_000) : 0.0;		
        	}

            private double[] positions;
        	private double[] velocities;
            private double[] lifetimes;
            private int pointIndex;
            private Point[] points;
            private BufferStrategy bufferStrategy;
            private ThreadLocalRandom random;

        } // End DrawingCycle class

        private final class InputHandler extends KeyAdapter {
   		
    		@Override
    		public void keyPressed(KeyEvent aKeyEvent) {
    			final int keyCode = aKeyEvent.getKeyCode();
    			switch ( keyCode ) {
    				case KeyEvent.VK_UP        -> saturation = Math.min(saturation + 0.1, 1.0);
    				case KeyEvent.VK_DOWN      -> saturation = Math.max(saturation - 0.1, 0.0);
    				case KeyEvent.VK_PAGE_UP   -> spread = Math.min(spread + 0.1, 5.0);
    				case KeyEvent.VK_PAGE_DOWN -> spread = Math.max(spread - 0.1, 0.5);
    				case KeyEvent.VK_RIGHT     -> range = Math.min(range + 0.1, 2.0);
    				case KeyEvent.VK_LEFT      -> range = Math.max(range + 0.1, 0.1);
    				case KeyEvent.VK_SPACE     -> reciprocate = ! reciprocate;
    				case KeyEvent.VK_Q         -> Runtime.getRuntime().exit(0);
    				default -> { /* Take no action */ }
    			}	
    		}
    		
    	} // End InputHandler class

        private int particleCount;
    	private int width;
    	private int height;
    	private double saturation;
     	private double spread;
     	private double range;
     	private boolean reciprocate;	
    	private ExecutorService executorService;    	  	

    } // End ParticleFountain class

} // End ParticleFountainTask class
