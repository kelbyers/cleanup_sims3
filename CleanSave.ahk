WinActivate, ahk_exe s3pe.exe
WinWaitActive, ahk_exe s3pe.exe

; set "Tag" checkbox
Control, Check,, WindowsForms10.BUTTON.app.0.2a2cc74_r6_ad117, ahk_exe s3pe.exe

; Set "Resource Type" checkbox
Control, Check,, WindowsForms10.BUTTON.app.0.2a2cc74_r6_ad118, ahk_exe s3pe.exe

; Set "Filter active" checkbox
Control, Check,, WindowsForms10.BUTTON.app.0.2a2cc74_r6_ad113, ahk_exe s3pe.exe
WaitForUser("Continue after activating filters")

DeleteTagType("snap", "0x0580A2CE")
WaitForUser("Continue after deleting '0x0580a2c E'")
DeleteTagType("snap", "0x0580A2CD")
WaitForUser("Continue after deleting '0x0580a2c D'")

WinActivate, ahk_exe s3pe.exe
WinWaitActive, ahk_exe s3pe.exe
Send, !f
Send, x

return

DeleteTagType(tag, rtype)
{
	FilterTagType(tag, rtype)
	Sleep, 400
	WinActivate, ahk_exe s3pe.exe
	WinWaitActive, ahk_exe s3pe.exe
	Send, !re
	Sleep, 400
	Send, !rl
}

FilterTagType(tag, rtype)
{
	; fill in "Tag" value
	ControlClick, WindowsForms10.EDIT.app.0.2a2cc74_r6_ad13, ahk_exe s3pe.exe
	ControlSetText, WindowsForms10.EDIT.app.0.2a2cc74_r6_ad13, %tag%, ahk_exe s3pe.exe
	; fill in "Resource Type" value
	ControlClick, WindowsForms10.EDIT.app.0.2a2cc74_r6_ad15, ahk_exe s3pe.exe
	ControlSetText, WindowsForms10.EDIT.app.0.2a2cc74_r6_ad15, %rtype%, ahk_exe s3pe.exe
	; activate filter
	ControlClick, WindowsForms10.BUTTON.app.0.2a2cc74_r6_ad111, ahk_exe s3pe.exe
}

WaitForUser(msg)
{
	MsgBox, 0x1001,, %msg%
	IfMsgBox Cancel
		ExitApp
}
