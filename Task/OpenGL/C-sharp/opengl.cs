using OpenTK;
using OpenTK.Graphics;
namespace OpenGLTest
{
    class Program
    {
        static void Main(string[] args)
        {
            //Create the OpenGL window
            GameWindow window = new GameWindow(640, 480, GraphicsMode.Default, "OpenGL Example");

            GL.MatrixMode(MatrixMode.Projection);
            GL.LoadIdentity();
            GL.Ortho(-30.0, 30.0, -30.0, 30.0, -30.0, 30.0);
            GL.MatrixMode(MatrixMode.Modelview);

            //Add event handler to render to the window when called
            window.RenderFrame += new RenderFrameEvent(a_RenderFrame);
            //Starts the window's updating/rendering events
            window.Run();
        }
        static void a_RenderFrame(GameWindow sender, RenderFrameEventArgs e)
        {
            GL.ClearColor(0.3f, 0.3f, 0.3f, 0f);
            GL.Clear(ClearBufferMask.ColorBufferBit | ClearBufferMask.DepthBufferBit);

            GL.ShadeModel(ShadingModel.Smooth);

            GL.LoadIdentity();
            GL.Translate(-15.0f, -15.0f, 0.0f);

            GL.Begin(BeginMode.Triangles);
            GL.Color3(1.0f, 0.0f, 0.0f);
            GL.Vertex2(0.0f, 0.0f);
            GL.Color3(0.0f, 1.0f, 0.0f);
            GL.Vertex2(30f, 0.0f);
            GL.Color3(0.0f, 0.0f, 1.0f);
            GL.Vertex2(0.0f, 30.0f);
            GL.End();
            //Swaps the buffers on the window so that what we draw becomes visible
            sender.SwapBuffers();
        }
    }
}
