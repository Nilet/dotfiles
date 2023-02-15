; firefox, raise or launch on f7
F6::
IfWinExist ahk_exe firefox.exe
{
WinActivate, ahk_exe firefox.exe
return
}
IfWinNotExist ahk_exe firefox.exe
{
Run, firefox.exe
return
}

; windows terminal, raise or launch on F7 or Win+Enter
#Enter::
F7::
IfWinExist ahk_exe WindowsTerminal.exe
{
WinActivate, ahk_exe WindowsTerminal.exe
return
}
IfWinNotExist ahk_exe WindowsTerminal.exe
{
Run, wt.exe
return
}

; Spotify, raise or launch on Insert
Insert::
IfWinExist ahk_exe Spotify.exe
{
WinActivate, ahk_exe Spotify.exe
return
}
IfWinNotExist ahk_exe Spotify.exe
{
Run, spotify.exe
return
}

; toggle maximize on F1
F1::toggleMaxWindow()
toggleMaxWindow()
{
  WinGet, WinState, MinMax, A
  if (WinState = 1)
  {
    WinRestore, A
  }
  else
  {
    WinMaximize, A
  }
}

;jump to last active windows with f1
F2::Send !{Tab}
; close window with f4
F4::Send !{F4}
;; scrollLock toggles hotkeys on and off, useful for gaming
Pause::Suspend
