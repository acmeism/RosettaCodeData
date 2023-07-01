#include <windows.h>
#include "resource.h"

BOOL CALLBACK DlgProc( HWND hwnd, UINT msg, WPARAM wPar, LPARAM lPar ) {
    switch( msg ) {

        case WM_INITDIALOG:
            srand( GetTickCount() );
            SetDlgItemInt( hwnd, IDC_INPUT, 0, FALSE );
            break;

        case WM_COMMAND:
            switch( LOWORD(wPar) ) {
                case IDC_INCREMENT: {
                    UINT n = GetDlgItemInt( hwnd, IDC_INPUT, NULL, FALSE );
                    SetDlgItemInt( hwnd, IDC_INPUT, ++n, FALSE );
                    } break;
                case IDC_RANDOM: {
                    int reply = MessageBox( hwnd,
                        "Do you really want to\nget a random number?",
                        "Random input confirmation", MB_ICONQUESTION|MB_YESNO );
                    if( reply == IDYES )
                        SetDlgItemInt( hwnd, IDC_INPUT, rand(), FALSE );
                    } break;
                case IDC_QUIT:
                    SendMessage( hwnd, WM_CLOSE, 0, 0 );
                    break;
                default: ;
            }
            break;

        case WM_CLOSE: {
            int reply = MessageBox( hwnd,
                "Do you really want to quit?",
                "Quit confirmation", MB_ICONQUESTION|MB_YESNO );
            if( reply == IDYES )
                EndDialog( hwnd, 0 );
            } break;

        default: ;
    }

    return 0;
}

int WINAPI WinMain( HINSTANCE hInst, HINSTANCE hPInst, LPSTR cmdLn, int show ) {
    return DialogBox( hInst, MAKEINTRESOURCE(IDD_DLG), NULL, DlgProc );
}
