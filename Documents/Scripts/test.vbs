strInfo = "3101234567 Ryan Maybach"

Dim varSplit 'as Variant
varSplit = Split(strInfo, " ")

strPhoneNumber = varSplit(0)
strOwner = varSplit(1)

MsgBox strPhoneNumber & " - " & strOwner