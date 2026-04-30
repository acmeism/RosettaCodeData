with System.Address_To_Access_Conversions;
with Lumen.Window;
with Lumen.Image;
with Lumen.Events;
with GL;
with Mandelbrot;

procedure Test_Mandelbrot is

   Program_End : exception;

   Win : Lumen.Window.Handle;
   Image : Lumen.Image.Descriptor;
   Tx_Name : aliased GL.GLuint;
   Wide, High : Natural := 400;

   -- Create a texture and bind a 2D image to it
   procedure Create_Texture is
      use GL;

      package GLB is new System.Address_To_Access_Conversions (GLubyte);

      IP : GLpointer;
   begin  -- Create_Texture
      -- Allocate a texture name
      glGenTextures (1, Tx_Name'Unchecked_Access);

      -- Bind texture operations to the newly-created texture name
      glBindTexture (GL_TEXTURE_2D, Tx_Name);

      -- Select modulate to mix texture with color for shading
      glTexEnvi (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

      -- Wrap textures at both edges
      glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

      -- How the texture behaves when minified and magnified
      glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
      glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

      -- Create a pointer to the image.  This sort of horror show is going to
      -- be disappearing once Lumen includes its own OpenGL bindings.
      IP := GLB.To_Pointer (Image.Values.all'Address).all'Unchecked_Access;

      -- Build our texture from the image we loaded earlier
      glTexImage2D (GL_TEXTURE_2D, 0, GL_RGBA, GLsizei (Image.Width), GLsizei (Image.Height), 0,
                    GL_RGBA, GL_UNSIGNED_BYTE, IP);
   end Create_Texture;

   -- Set or reset the window view parameters
   procedure Set_View (W, H : in Natural) is
      use GL;
   begin  -- Set_View
      GL.glEnable (GL.GL_TEXTURE_2D);
      glClearColor (0.8, 0.8, 0.8, 1.0);

      glMatrixMode (GL_PROJECTION);
      glLoadIdentity;
      glViewport (0, 0, GLsizei (W), GLsizei (H));
      glOrtho (0.0, GLdouble (W), GLdouble (H), 0.0, -1.0, 1.0);

      glMatrixMode (GL_MODELVIEW);
      glLoadIdentity;
   end Set_View;

   -- Draw our scene
   procedure Draw is
      use GL;
   begin  -- Draw
      -- clear the screen
      glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
      GL.glBindTexture (GL.GL_TEXTURE_2D, Tx_Name);

      -- fill with a single textured quad
      glBegin (GL_QUADS);
      begin
         glTexCoord2f (1.0, 0.0);
         glVertex2i (GLint (Wide), 0);

         glTexCoord2f (0.0, 0.0);
         glVertex2i (0, 0);

         glTexCoord2f (0.0, 1.0);
         glVertex2i (0, GLint (High));

         glTexCoord2f (1.0, 1.0);
         glVertex2i (GLint (Wide), GLint (High));
      end;
      glEnd;

      -- flush rendering pipeline
      glFlush;

      -- Now show it
      Lumen.Window.Swap (Win);
   end Draw;

   -- Simple event handler routine for keypresses and close-window events
   procedure Quit_Handler (Event : in Lumen.Events.Event_Data) is
   begin  -- Quit_Handler
      raise Program_End;
   end Quit_Handler;

   -- Simple event handler routine for Exposed events
   procedure Expose_Handler (Event : in Lumen.Events.Event_Data) is
      pragma Unreferenced (Event);
   begin  -- Expose_Handler
      Draw;
   end Expose_Handler;

   -- Simple event handler routine for Resized events
   procedure Resize_Handler (Event : in Lumen.Events.Event_Data) is
   begin  -- Resize_Handler
      Wide := Event.Resize_Data.Width;
      High := Event.Resize_Data.Height;
      Set_View (Wide, High);
--        Image := Mandelbrot.Create_Image (Width => Wide, Height => High);
--        Create_Texture;
      Draw;
   end Resize_Handler;

begin
   -- Create Lumen window, accepting most defaults; turn double buffering off
   -- for simplicity
   Lumen.Window.Create (Win           => Win,
                        Name          => "Mandelbrot fractal",
                        Width         => Wide,
                        Height        => High,
                        Events        => (Lumen.Window.Want_Exposure  => True,
                                          Lumen.Window.Want_Key_Press => True,
                                          others                      => False));

   -- Set up the viewport and scene parameters
   Set_View (Wide, High);

   -- Now create the texture and set up to use it
   Image := Mandelbrot.Create_Image (Width => Wide, Height => High);
   Create_Texture;

   -- Enter the event loop
   declare
      use Lumen.Events;
   begin
      Select_Events (Win   => Win,
                     Calls => (Key_Press    => Quit_Handler'Unrestricted_Access,
                               Exposed      => Expose_Handler'Unrestricted_Access,
                               Resized      => Resize_Handler'Unrestricted_Access,
                               Close_Window => Quit_Handler'Unrestricted_Access,
                               others       => No_Callback));
   end;
exception
   when Program_End =>
      null;
end Test_Mandelbrot;
