 import derelict.sdl.sdl;

 int main(char[][] args)
 {
     DerelictSDL.load();

     SDL_Event event;
     auto done = false;

     SDL_Init(SDL_INIT_VIDEO);
     scope(exit) SDL_Quit();

     SDL_SetVideoMode(1024, 768, 0, SDL_OPENGL);
     SDL_WM_SetCaption("My first Window", "SDL test");
 	
     while (!done)
     {
         if (SDL_PollEvent(&event) == 1)
         {
             switch (event.type)
 	     {
                 case SDL_QUIT:
 	              done = true;
 		          break;
 		 default:
 		      break;
 	     }
 	 }		
     }

    return 0;
 }
