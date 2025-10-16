Dim WShell, Script  
Set WShell = CreateObject("WScript.Shell")  
Script = "C:\Program Files (x86)\83t460\83t460-client.cmd"

if WScript.Arguments.count > 0 then  
    Set oAL = CreateObject("System.Collections.ArrayList")  
    For Each oItem In Wscript.Arguments:  
        oAL.Add oItem:  
    Next  
    Args = Join(oAL.ToArray, " ")  
end if  

WShell.Run """" & Script & """" & " " & Args, 0, 1
Set WShell = Nothing
