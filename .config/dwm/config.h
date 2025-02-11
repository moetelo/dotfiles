#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const char *fonts[]          = { "SetoFontFixed:size=16" };
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_green[]        = "#578545";

static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */

// client.focused   #373B41 #F0C674AA #000000 #DABAD7   #578545
// client.unfocused #373B41 #373B41 #888888 #292d2e   #222222

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_green,  col_green  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "discord",     NULL,       NULL,       1 << 8,            0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#include "fibonacci.c"
static const Layout layouts[] = {
	{ "[]=", tile },
	{ "[@]", spiral },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD_RAW(cmd) { (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define SHCMD(cmd) { .v = SHCMD_RAW(cmd) }

/* commands */
static const char *roficmd[] = { "rofi", "-show", "drun", "-show-icons", "-icon-theme", "Breath2", "-width", "50", NULL };
static const char *termcmd[]  = { "st", NULL };

static const Key keys[] = {
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd} },

	{ MODKEY,                       XK_d,      spawn,          {.v = roficmd} },

	{ MODKEY,                       XK_e,      spawn,          SHCMD("thunar") },
	{ MODKEY,                       XK_s,      spawn,          SHCMD("LC_MONETARY=ru_RU.UTF-8 rofi -show calc") },

	{ MODKEY|ShiftMask,             XK_s,      spawn,          SHCMD("flameshot gui") },

	{ MODKEY,                       XK_Tab,       zoom,           {0} },
	{ MODKEY,                       XK_backslash, zoom,           {0} },

	// bindsym $mod+c exec --no-startup-id rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
	// # bindsym $mod+Shift+e exec rofi -show power-menu -modi power-menu:$HOME/scripts/rofi-power-menu
	// bindsym $mod+Shift+e exec shutdown now

	{ MODKEY,             			XK_f,      togglefullscr,  {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_p,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },

	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_space,  togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },

	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	{ 0,							XF86XK_AudioPlay, spawn,      SHCMD("playerctl play-pause") },
	{ 0,							XF86XK_AudioPause, spawn,      SHCMD("playerctl play-pause") },
	{ 0,							XF86XK_AudioNext, spawn,      SHCMD("playerctl next") },
	{ 0,							XF86XK_AudioPrev, spawn,      SHCMD("playerctl previous") },

	{ 0, 							XF86XK_AudioRaiseVolume, spawn,  SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +5%") },
	{ 0, 							XF86XK_AudioLowerVolume, spawn,  SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%") },
	{ 0, 							XF86XK_AudioMute, spawn, 		 SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle") },
	{ 0, 							XF86XK_AudioMicMute, spawn, 	 SHCMD("pactl set-source-mute @DEFAULT_SOURCE@ toggle") },

	{ 0, 							XF86XK_MonBrightnessDown, spawn, SHCMD("brightnessctl set 10%-") },
	{ 0, 							XF86XK_MonBrightnessUp, spawn, 	 SHCMD("brightnessctl set 10%+") },
	{ MODKEY,                       XK_F7, spawn,     				 SHCMD("brightnessctl set 10%-") },
	{ MODKEY,                       XK_F8, spawn,     				 SHCMD("brightnessctl set 10%+") },
	{ MODKEY,                       XK_F11, spawn,     				 SHCMD("ddcutil setvcp 10 --bus 5 - 10") },
	{ MODKEY,                       XK_F12, spawn,     				 SHCMD("ddcutil setvcp 10 --bus 5 + 10") },

	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_e,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },

	// bindsym --release Print exec --no-startup-id maim | xclip -selection clipboard -t image/png
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	/* placemouse options, choose which feels more natural:
	 *    0 - tiled position is relative to mouse cursor
	 *    1 - tiled postiion is relative to window center
	 *    2 - mouse pointer warps to window center
	 *
	 * The moveorplace uses movemouse or placemouse depending on the floating state
	 * of the selected client. Set up individual keybindings for the two if you want
	 * to control these separately (i.e. to retain the feature to move a tiled window
	 * into a floating position).
	 */
	{ ClkClientWin,         MODKEY,         Button1,        moveorplace,    {.i = 1} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
