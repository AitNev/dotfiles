@echo off
setlocal enabledelayedexpansion

set "vpn_ip=MYVPNIP"
set "gateway_ip=ROUTERIP"

if "%1"=="postdown" (
    echo Running PostDown stage
    route delete %vpn_ip%
    goto exiting
)

:getInterfaces
rem Define the search string
set "wg_name=WireGuard Tunnel"
set "wifi_name=Intel(R)"

set flag=false
for /F "delims=" %%a in ('route print') do (
    if "!flag!" == "true" (
        if "%%a" equ "===========================================================================" (
            goto endGetInterfaces
        ) else (
		for /f "tokens=1,* delims=." %%a in ('echo %%a ^| findstr /i "!wg_name!"') do (
    			set "wg_interface=%%a"
    			set "wg_interface=!wg_interface: =!"
		)
		for /f "tokens=1,* delims=." %%a in ('echo %%a ^| findstr /i "!wifi_name!"') do (
    			set "wifi_interface=%%a"
    			set "wifi_interface=!wifi_interface: =!"
		)
	)
    )
    if "%%a" equ "Interface List" (
        set flag=true
    )
)
:endGetInterfaces

if "%1"=="preup" (
    echo Running PreUp stage !wifi_interface!
    route add %vpn_ip% mask 255.255.255.255 %gateway_ip% if %wifi_interface% metric 1
    route change 0.0.0.0 mask 0.0.0.0 %gateway_ip% if %wifi_interface% metric 100
)

if "%1"=="postup" (
    echo Running PostUp stage !wg_interface!
    route add 0.0.0.0 mask 0.0.0.0 0.0.0.0 metric 80 if %wg_interface%
)

:exiting