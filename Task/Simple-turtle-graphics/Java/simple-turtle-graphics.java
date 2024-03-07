/* Class Turtle starts here */

import java.awt.geom.AffineTransform;

public class Turtle extends java.lang.Object
{
	private final java.awt.Graphics2D origin;
	private java.awt.Graphics2D g2;

	public Turtle(java.awt.Graphics2D origin)
	{
		this.origin = origin;
		origin();
	}
	public void origin()
	{
		g2=(java.awt.Graphics2D)origin.create();
	}
	public void relativePosition(int xoff, int yoff)
	{
		AffineTransform at=g2.getTransform();
		at.concatenate(AffineTransform.
                       getTranslateInstance(xoff,yoff));
		g2.setTransform(at);
	}
	public void turnByDegrees(int thetaInDegrees)
	{
		AffineTransform at=g2.getTransform();
		at.concatenate(AffineTransform.
                       getRotateInstance(Math.toRadians(thetaInDegrees)));
		g2.setTransform(at);
	}
	public void forward(int len)
	{
		g2.drawLine(0,0,len,0);
		relativePosition(len,0);
	}
}

/* Class CanvasComponent starts here*/

import java.awt.Graphics;
import java.awt.Graphics2D;

public class CanvasComponent extends javax.swing.JComponent
{
    protected void paintComponent(Graphics g)
    {
        Turtle turtle=new Turtle((Graphics2D)g);

        turtle.origin();

        turtle.relativePosition(50,50);

        house(turtle,100,200,50);

        turtle.origin();

        turtle.relativePosition(200,50);

        double[] numbers=new double[]{0.5, 0.33333, 2, 1.3, 0.5};

        barchart(turtle,200,numbers);
    }
    private void barchart(Turtle turtle,int size,double[] numbers)
    {
        double max=0;
        for(double d:numbers)
        {
            if(d>max)
                max=d;
        }
        double width=size/ numbers.length;
        int xpos=400;
        for(double d:numbers)
        {
            int h=(int) (size * (d / max));
            rectangle(turtle, (int)width, h);
            xpos+=width;
            turtle.relativePosition((int)width,0);
        }
    }
    private void house(Turtle turtle,int width,
                       int height, int roofheight)
    {
        rectangle(turtle,width,height);
        turtle.relativePosition(0,height);
        double dist= Math.sqrt(roofheight*roofheight+width/2*width/2);
        double angle= Math.toDegrees(Math.asin(roofheight/dist));
        turtle.turnByDegrees((int)angle);
        turtle.forward((int)dist);
        turtle.turnByDegrees(-2*(int)angle);
        turtle.forward((int)dist);
    }
    private void rectangle(Turtle turtle,int width, int height)
    {
        for(int i=0;i<2;++i)
        {
            turtle.forward(width);
            turtle.turnByDegrees(90);
            turtle.forward(height);
            turtle.turnByDegrees(90);
        }

    }
}

/* Class MainClass starts here */

import javax.swing.*;
import java.awt.*;

public class MainClass
{
    public static void main(String[] args)
    {
        CanvasComponent canvas=new CanvasComponent();
        canvas.setPreferredSize(new Dimension(800,600));
        JFrame f=new JFrame();
        JPanel p=new JPanel(new BorderLayout());
        p.add(canvas);
        f.setContentPane(p);
        f.setDefaultCloseOperation(f.EXIT_ON_CLOSE);
        f.pack();
        f.setVisible(true);
    }
}
