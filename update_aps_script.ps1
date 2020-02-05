$SerCpTo = "G:\Daten\FA\Software\AnalystPortfolioSynchronizer\"
$LocCpFrom = "C:\Development_TFS\Code\AnalystPortfolioSynchronizer\AnalystPortfolioSynchronizer\bin\Debug\*"
$LocRmFrom = "C:\temp\APS\*"
$LocCpTo = "C:\temp\APS\"

$Logfile = "C:\Projects\UpdateAPSscript\Log\log.txt"
If($Logfile){
  Remove-Item -Path $Logfile -Recurse –force
}

Function LogWrite {

    Param ([string]$logstring)
    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $Line = "$Stamp $logstring"
    Add-Content $Logfile -Value $Line
}

LogWrite "Start of copying"

Remove-Item -Path $LocRmFrom -Recurse  –force
LogWrite "Everything has been deleted from:  $LocRmFrom"

Copy-Item -Path $LocCpFrom -Destination $LocCpTo -Recurse
LogWrite "Copied from $LocCpFrom to: $LocCpTo" 

$List = Get-ChildItem -Path $SerCpTo | foreach-Object { $_.name -as [int] } | Sort-Object -Descending

$LatestVersion = $List[0]
LogWrite  "LatestVersion is: $LatestVersion" 

$NewVersion = [int]$LatestVersion + 1
LogWrite  "NewVersion is: $NewVersion" 

$SerCpToNew = [string]$SerCpTo + [string]$NewVersion 

New-Item $SerCpToNew -itemtype directory
LogWrite  "New direcory has been created: $SerCpToNew" 

Copy-Item -Path $LocCpFrom -Destination $SerCpToNew -Recurse
LogWrite  "Copied from $LocCpFrom to: $SerCpToNew" 

LogWrite  "Success!"