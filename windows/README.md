# WINDOWS

## Basic stuff

1. First of all we need to access [ninite](https://ninite.com/) and install some stuff

2. Then we install *autohotkey* from the executable that it is available in this folder

3. With *autohotkey* installed and running we need to create a shortcut for the .ahk and place them into the startup folder, we can access the folder by pressing `Windows + r` and running `shell:startup`

## Stuff that might be nice to have

- [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/install) 

- Install [chocolatey](https://chocolatey.org/install) by running *powershell* as admin and run 
```Set-ExecutionPolicy AllSigned```

and then 

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

now we are allowed to use *choco* to install *mpv* and *qView*

- [Debloat Windows](https://github.com/LeDragoX/Win-Debloat-Tools)

- [AltDrag](https://stefansundin.github.io/altdrag/) for QoL
- Some [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/install) might be nice 

- And if I am going full windows as daily driver i might need [ArchWSL](https://github.com/yuk7/ArchWSL)


