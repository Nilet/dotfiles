; firefox, raise or launch on f7
F6::
IfWinExist ahk_class MozillaWindowClass
{
WinActivate, ahk_class MozillaWindowClass
return
}
IfWinNotExist ahk_class MozillaWindowClass
{
Run, firefox.exe
return
}

; windows terminal, raise or launch on f9
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

; close window with f4
F4::Send !{F4}
;; scrollLock toggles hotkeys on and off, useful for gaming
Pause::Suspend
