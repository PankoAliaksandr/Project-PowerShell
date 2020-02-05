$SerCpFrom = "G:\Daten\FA\Software\AnalystPortfolioSynchronizer\"
$SerAllVersions = "G:\Daten\FA\Software\AnalystPortfolioSynchronizer\"
$LocRmFrom = "C:\temp\APS\*"
$LocCpTo = "C:\temp\APS\"

Function LogWrite{
  Param ([string]$logstring)
  $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
  $Line = "$Stamp $logstring"
  Add-Content $Logfile -Value $Line
}

$Logfile = "C:\temp\APS\CopyLog.txt"

If(Test-Path $LocCpTo -PathType Container){
  Remove-Item -Path $LocRmFrom -Recurse  –force
  LogWrite "Everything has been deleted from:  $LocCpTo"
}Else{
  New-Item -Path $LocCpTo -ItemType "directory"
  LogWrite "A new folder has been created:  $LocCpTo"
}

If([System.IO.File]::Exists("C:\temp\APS\Log\log.txt")){
  Remove-Item -Path $Logfile -Recurse –force
  LogWrite "Existed Log has been deleted"
  New-Item -Path $Logfile -ItemType "file" -Value "This file will be a log."
  LogWrite "Empty Log has been created here $Logfile"
}

LogWrite "Start of copying"

$List = Get-ChildItem -Path $SerCpFrom | foreach-Object { $_.name -as [int] } | Sort-Object -Descending

$LatestVersion = $List[0]
LogWrite  "LatestVersion is: $LatestVersion" 

$SerLatestVersionFrom = [string]$SerCpFrom + [string]$LatestVersion + "\*"

Copy-Item -Path $SerLatestVersionFrom -Destination $LocCpTo -Recurse

LogWrite  "LatestVersion $LatestVersion has been copied from $SerLatestVersionFrom to $LocCpTo" 