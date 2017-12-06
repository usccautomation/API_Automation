Set fs = CreateObject("Scripting.FileSystemObject")
Set MainFolder = fs.GetFolder("C:\GingerSolutions\APIAutomation\Documents\WebServices\SoapUI\ExecutionOutputs")
For Each fldr In MainFolder.SubFolders
    ''As per comment
    If fldr.DateLastModified > LastDate Or IsEmpty(LastDate) Then
        LastFolder = fldr.Name
        LastDate = fldr.DateLastModified
    End If
Next


  Dim oLstPng : Set oLstPng = Nothing
  'Dim oFolder 
  'Set oFolder = "C:\GingerSolutions\APIAutomation\Documents\WebServices\SoapUI\ExecutionOutputs\" & LastFolder
  Dim oFile
  Dim goFS    : Set goFS    = CreateObject("Scripting.FileSystemObject")
  For Each oFile In goFS.GetFolder("C:\GingerSolutions\APIAutomation\Documents\WebServices\SoapUI\ExecutionOutputs\" & LastFolder).Files
      If "txt" = LCase(goFS.GetExtensionName(oFile.Name)) Then
         If oLstPng Is Nothing Then 
            Set oLstPng = oFile ' the first could be the last
         Else
            If oLstPng.DateLastModified < oFile.DateLastModified Then
               Set oLstPng = oFile
            End If
         End If
      End If
  Next
  If oLstPng Is Nothing Then
     'WScript.Echo "no .txt found"
  Else
     'WScript.Echo "found", LastFolder, " -- ", oLstPng.Name
	 
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set f = fso.OpenTextFile("C:\GingerSolutions\APIAutomation\Documents\WebServices\SoapUI\ExecutionOutputs\" & LastFolder & "\" & oLstPng.Name,1)
	Bodytext = f.ReadAll

	f.Close
	Set f = Nothing
	Set fso = Nothing
	Set args = WScript.Arguments
	
	txtArgs = args.Item(0)
	Dim varSplit 
	varSplit = Split(txtArgs, "-")
	env = varSplit(0)
	flow = varSplit(1)
		
	 Set email = CreateObject("CDO.Message")
 
		email.Subject = env & " | API Sanity | " & flow &" Failed due to mentioned error in email body" 
		email.From = "USCCAutomation@uscellular.com"
		email.To = "uday.choudhary@amdocs.com"

		email.Textbody  = BodyText 
 
	email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "exchange-usc.int.usc.local"
	email.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
 
	email.Configuration.Fields.Update
	email.Send
	set email = Nothing
  End If


