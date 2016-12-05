#include <windows.h>
#include "resource.h"

#define MIN_VALUE    0
#define MAX_VALUE   10

BOOL CALLBACK DlgProc( HWND hwnd, UINT msg, WPARAM wPar, LPARAM lPar );
void Increment( HWND hwnd );
void Decrement( HWND hwnd );
void SetControlsState( HWND hwnd );

int WINAPI WinMain( HINSTANCE hInst, HINSTANCE hPInst, LPSTR cmdLn, int show ) {
    return DialogBox( hInst, MAKEINTRESOURCE(IDD_DLG), NULL, DlgProc );
}

BOOL CALLBACK DlgProc( HWND hwnd, UINT msg, WPARAM wPar, LPARAM lPar ) {
    switch( msg ) {

        case WM_INITDIALOG:
            srand( GetTickCount() );
            SetDlgItemInt( hwnd, IDC_INPUT, 0, FALSE );
            break;

        case WM_COMMAND:
            switch( LOWORD(wPar) ) {
                case IDC_INCREMENT:
                    Increment( hwnd );
                    break;
                case IDC_DECREMENT:
                    Decrement( hwnd );
                    break;
                case IDC_INPUT:
                    // update controls' state according
                    // to the contents of the input field
                    if( HIWORD(wPar) == EN_CHANGE ) SetControlsState( hwnd );
                    break;
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

void Increment( HWND hwnd ) {
    UINT n = GetDlgItemInt( hwnd, IDC_INPUT, NULL, FALSE );

    if( n < MAX_VALUE ) {
        SetDlgItemInt( hwnd, IDC_INPUT, ++n, FALSE );
        SetControlsState( hwnd );
    }
}

void Decrement( HWND hwnd ) {
    UINT n = GetDlgItemInt( hwnd, IDC_INPUT, NULL, FALSE );

    if( n > MIN_VALUE ) {
        SetDlgItemInt( hwnd, IDC_INPUT, --n, FALSE );
        SetControlsState( hwnd );
    }
}

void SetControlsState( HWND hwnd ) {
    UINT n = GetDlgItemInt( hwnd, IDC_INPUT, NULL, FALSE );
    EnableWindow( GetDlgItem(hwnd,IDC_INCREMENT), n<MAX_VALUE );
    EnableWindow( GetDlgItem(hwnd,IDC_DECREMENT), n>MIN_VALUE );
}
