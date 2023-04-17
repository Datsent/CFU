SCHTASKS  /CREATE /SC ONLOGON /TN "UNI\CFU" /TR "%CD%\start.vbs"
pause