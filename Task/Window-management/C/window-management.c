#include<windows.h>
#include<unistd.h>
#include<stdio.h>

const char g_szClassName[] = "weirdWindow";

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch(msg)
    {
        case WM_CLOSE:
            DestroyWindow(hwnd);
        break;
        case WM_DESTROY:
            PostQuitMessage(0);
        break;
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
{
    WNDCLASSEX wc;
    HWND hwnd[3];
    MSG Msg;
	int i,x=0,y=0;
	char str[3][100];
	int maxX = GetSystemMetrics(SM_CXSCREEN), maxY = GetSystemMetrics(SM_CYSCREEN);
	
	char messages[15][180] = {"Welcome to the Rosettacode Window C implementation.",
	"If you can see two blank windows just behind this message box, you are in luck.",
	"Let's get started....",
	"Yes, you will be seeing a lot of me :)",
	"Now to get started with the tasks, the windows here are stored in an array of type HWND, the array is called hwnd (yes, I know it's very innovative.)",
	"Let's compare the windows for equality.",
	"Now let's hide Window 1.",
	"Now let's see Window 1 again.",
	"Let's close Window 2, bye, bye, Number 2 !",
	"Let's minimize Window 1.",
	"Now let's maximize Window 1.",
	"And finally we come to the fun part, watch Window 1 move !",
	"Let's double Window 1 in size for all the good work.",
	"That's all folks ! (You still have to close that window, that was not part of the contract, sue me :D )"};

    wc.cbSize        = sizeof(WNDCLASSEX);
    wc.style         = 0;
    wc.lpfnWndProc   = WndProc;
    wc.cbClsExtra    = 0;
    wc.cbWndExtra    = 0;
    wc.hInstance     = hInstance;
    wc.hIcon         = LoadIcon(NULL, IDI_APPLICATION);
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
    wc.lpszMenuName  = NULL;
    wc.lpszClassName = g_szClassName;
    wc.hIconSm       = LoadIcon(NULL, IDI_APPLICATION);

    if(!RegisterClassEx(&wc))
    {
        MessageBox(NULL, "Window Registration Failed!", "Error!",MB_ICONEXCLAMATION | MB_OK);
        return 0;
    }

	for(i=0;i<2;i++){
		
		sprintf(str[i],"Window Number %d",i+1);
		
		hwnd[i] = CreateWindow(g_szClassName,str[i],WS_OVERLAPPEDWINDOW,i*maxX/2 , 0, maxX/2-10, maxY/2-10,NULL, NULL, hInstance, NULL);
		
		if(hwnd[i] == NULL)
		{
			MessageBox(NULL, "Window Creation Failed!", "Error!",MB_ICONEXCLAMATION | MB_OK);
			return 0;
		}

		ShowWindow(hwnd[i], nCmdShow);
		UpdateWindow(hwnd[i]);
	}
	
	for(i=0;i<6;i++){
			MessageBox(NULL, messages[i], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);		
	}
	
	if(hwnd[0]==hwnd[1])
			MessageBox(NULL, "Window 1 and 2 are equal.", "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	else
			MessageBox(NULL, "Nope, they are not.", "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
		
	MessageBox(NULL, messages[6], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	ShowWindow(hwnd[0], SW_HIDE);
	
	MessageBox(NULL, messages[7], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	ShowWindow(hwnd[0], SW_SHOW);
	
	MessageBox(NULL, messages[8], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	ShowWindow(hwnd[1], SW_HIDE);
	
	MessageBox(NULL, messages[9], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	ShowWindow(hwnd[0], SW_MINIMIZE);
	
	MessageBox(NULL, messages[10], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	ShowWindow(hwnd[0], SW_MAXIMIZE);
	
	MessageBox(NULL, messages[11], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	ShowWindow(hwnd[0], SW_RESTORE);
	
	while(x!=maxX/2||y!=maxY/2){
		if(x<maxX/2)
			x++;
		if(y<maxY/2)
			y++;
		
		MoveWindow(hwnd[0],x,y,maxX/2-10, maxY/2-10,0);
		sleep(10);
	}
	
	MessageBox(NULL, messages[12], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);
	
	MoveWindow(hwnd[0],0,0,maxX, maxY,0);
	
	MessageBox(NULL, messages[13], "Info",MB_APPLMODAL| MB_ICONINFORMATION | MB_OK);

    while(GetMessage(&Msg, NULL, 0, 0) > 0)
    {
        TranslateMessage(&Msg);
        DispatchMessage(&Msg);
    }
    return Msg.wParam;
}
