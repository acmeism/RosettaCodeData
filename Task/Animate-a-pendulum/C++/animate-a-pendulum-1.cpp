#ifndef __wxPendulumDlg_h__
#define __wxPendulumDlg_h__

// ---------------------
/// @author Martin Ettl
/// @date   2013-02-03
// ---------------------

#ifdef __BORLANDC__
#pragma hdrstop
#endif

#ifndef WX_PRECOMP
#include <wx/wx.h>
#include <wx/dialog.h>
#else
#include <wx/wxprec.h>
#endif
#include <wx/timer.h>
#include <wx/dcbuffer.h>
#include <cmath>

class wxPendulumDlgApp : public wxApp
{
    public:
        bool OnInit();
        int OnExit();
};

class wxPendulumDlg : public wxDialog
{
    public:

        wxPendulumDlg(wxWindow *parent, wxWindowID id = 1, const wxString &title = wxT("wxPendulum"),
				 const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize,
				 long style = wxSUNKEN_BORDER | wxCAPTION | wxRESIZE_BORDER | wxSYSTEM_MENU | wxDIALOG_NO_PARENT | wxMINIMIZE_BOX | wxMAXIMIZE_BOX | wxCLOSE_BOX);

        virtual ~wxPendulumDlg();
	
		// Event handler
        void wxPendulumDlgPaint(wxPaintEvent& event);
        void wxPendulumDlgSize(wxSizeEvent& event);
        void OnTimer(wxTimerEvent& event);

    private:

		// a pointer to a timer object
        wxTimer *m_timer;

		unsigned int m_uiLength;
		double  	 m_Angle;
		double       m_AngleVelocity;

        enum wxIDs
        {
            ID_WXTIMER1 = 1001,
            ID_DUMMY_VALUE_
        };

        void OnClose(wxCloseEvent& event);
        void CreateGUIControls();

        DECLARE_EVENT_TABLE()
};

#endif // __wxPendulumDlg_h__
