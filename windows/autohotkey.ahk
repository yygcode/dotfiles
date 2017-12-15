;^#e::Run C:\cygwin64\bin\run.exe emacs-w32.exe -fs

EnvSet, MSYS2_ROOT, F:\msys64
EnvSet, PATH, %MSYS2_ROOT%\usr\bin;%MSYS2_ROOT%\mingw64\bin;C:\ProgramData\Oracle\Java\javapath;%PATH%
EnvSet, HTTP_PROXY, 127.0.0.1:49529
EnvSet, HTTPS_PROXY, 127.0.0.1:49529
EnvSet, FTP_PROXY, 127.0.0.1:49529
EnvSet, NO_PROXY, localhost,127.*,10.*,*.jd.*,*.baidu.*,*.icbc.*,*.bing.*,*.taobao.*,*.csdn.*
EnvSet, http_proxy, %HTTP_PROXY%
EnvSet, https_proxy, %HTTPS_PROXY%
EnvSet, no_proxy, %NO_PROXY%

^#e::Run C:\emacs-26.0.90-x86_64\bin\runemacs.exe -fs
^#m::Run %MSYS2_ROOT%\msys2_shell.cmd -mingw64
^#c::Run C:\cygwin64\bin\mintty.exe -
^#i::Run explorer.exe E:\work\inspur\FY17
^#b::Run C:\Windows\system32\bash.exe
^#f::Run C:\Program Files\Mozilla Firefox\firefox.exe
^#v::Run C:\Program Files (x86)\VMware\VMware Horizon View Client\vmware-view.exe

; google search: Ctrl+Win+g
^#g::Run https://www.google.com.hk/search?q=%clipboard%
^#t::Run chrome.exe http://www.iciba.com/%clipboard%

Capslock::Ctrl
Ctrl::Capslock
