<#
  Scriptnaam:  MonitorFreeMemory-MySQL-Edit-Leonardo-Al-Raihani.ps1 
  Doel      :  De gebruiker up-to-date houden over de vrije geheugen en hiervan een kopie opslaan in sql-file.
  Auteur    :  Leonardo Al-Raihani
  Versie    :  Versie 0.1
  Datum     :  5 november 2022
  Output	:  *.sql om in database ritmania de tabel "memoryusage" op te vullen.
  Verwachte argumenten: aantal seconden (numerieke waarde) en bestandsnaam voor het export-bestand.

#>

# Error handling
$ErrorActionPreference= 'silentlycontinue'

# Define defaults
$seconds = 20
$fileName = "Geheugen-export" + "-" + $getDate + ".sql"
$hostname = hostname

# Define Arguments
If ($args[0] -Is [int]) {$seconds = $args[0]};
If ($args[1] -Is [string]) {$fileName = $args[1] + ".sql"};

# Clear specific variables
$fileOptions = ""

# Define filename
$pattern = '[/]'
$getDate = Get-Date -Format d
$getDate = $getDate -replace $pattern, "-"
$folderName = "C:\windows\Temp\"
$fileLoc = $folderName + $fileName

# Define first timestamp
$currentTime = "{0:G}" -f (get-date)

# Clear screen for start
Clear-Host

# Message start
Write-Host "Process FreeMemoryCheckeris gestart op $currentTime"

# Create environment
if (Test-Path $folderName) {
    # File exists
}
else
{
    # File doesn't exists
}

# Switches preperation
$fileExists = Test-Path -Path $fileLoc -PathType Leaf
$choiceLow = 1
$choiceHigh = 3
$global:choiceMade = "leeg"

# Switches if file exist
If ($fileExists -eq $true) {
    Write-Host "Het opgegeven bestand bestaal al!"
    While (($fileOptions -lt $choiceLow) -or ($fileOptions -gt $choiceHigh)) {
        $fileOptions = Read-Host "Wil je de output van het script toevoegen, vervangen of wil je een nieuw bestand aanmaken?: `n 1: Aanvullen `n 2: Overschrijven `n 3: Script stoppen `n"
        Switch ($fileOptions)
        { 
            1 {$global:choiceMade = "Aanvullen"}
            2 {$global:choiceMade = "Overschrijven"}
            3 {$global:choiceMade = "Script stoppen"}
        }
        
    }
}
Else {
    Write-Host "Bestand bestaat niet. Script gaat verder..."
    New-Item -Path $fileLoc
}

Clear-Host
Write-Host "Keuze wordt nu uitgevoerd."
Start-Sleep 3

# Define seconds
$waitTime = New-Timespan -Seconds $seconds
$stopTime = (Get-Date) + $waitTime

# Literal hashes misconceptions
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# MySQL Variables
[string]$mysqlDate = get-date -Format "yyyy-MM-dd HH:mm:ss"
[string]$mysqlDatabase = "USE ritmania;"
[string]$mysqlInsert = "INSERT INTO"
[string]$mysqlTable = "    memoryusage (`n        hostname, freememory, date`n    )"
[string]$mysqlValues = "VALUES"

# Switches functions
If ($global:choicemade -eq "Aanvullen") {
    # MySQL use database
    Add-Content -Path $fileLoc -Value $mysqlDatabase
    # MySQL start inserting
    Add-Content -Path $fileLoc -Value $mysqlInsert
    # MySQL table selection
    Add-Content -Path $fileLoc -Value $mysqlTable
    # MySQL value selection
    Add-Content -Path $fileLoc -Value $mysqlValues
    # Start generating 
    Write-Host "Bestand wordt aangevuld."
    While ((Get-Date) -Lt $stopTime) {
        Clear-Host
        # Loading bar
        $timeLeft = $stopTime - (Get-Date)
        $timePassed = ((($seconds - $timeLeft.Seconds) / $seconds) * 100)
        $reversePercent = ($timeLeft.Seconds / $seconds * 100)
        $end  = "-" *($reversePercent / 4)
        $begin = "0" *($timePassed / 4)
        $rawMemory = (Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory) -replace "[^0-9]" , ''
        $percMemory = "{0:n2}" -f ($rawMemory / 1000000) + "GB vrij"
        Write-Host "[$begin$end]"
        Write-Host "|>     "  $percMemory "     <|"
        Write-Host "[$begin$end]"
        $currentTime = "{0:G}" -f (get-date)
        # MySQL values
        $mysqlStamps = "('" + $hostname + "'," + $rawMemory + ",'" + $mysqlDate + "'),"
        Add-Content -Path $fileLoc -Value $mysqlStamps
        Start-Sleep 2
    }    
}
ElseIf ($global:choicemade -eq "Overschrijven") {
    Write-Host "Script wordt overgeschreven."
    # Clear file
    Clear-Content -Path $fileLoc
    # MySQL use database
    Add-Content -Path $fileLoc -Value $mysqlDatabase
    # MySQL start inserting
    Add-Content -Path $fileLoc -Value $mysqlInsert
    # MySQL table selection
    Add-Content -Path $fileLoc -Value $mysqlTable
    # MySQL value selection
    Add-Content -Path $fileLoc -Value $mysqlValues
    # Start generating 
    While ((Get-Date) -Lt $stopTime) {
        Clear-Host
        # Loading bar
        $timeLeft = $stopTime - (Get-Date)
        $timePassed = ((($seconds - $timeLeft.Seconds) / $seconds) * 100)
        $reversePercent = ($timeLeft.Seconds / $seconds * 100)
        $end  = "-" *($reversePercent / 4)
        $begin = "0" *($timePassed / 4)
        $rawMemory = (Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory) -replace "[^0-9]" , ''
        $percMemory = "{0:n2}" -f ($rawMemory / 1000000) + "GB vrij"
        Write-Host "[$begin$end]"
        Write-Host "|>     "  $percMemory "     <|"
        Write-Host "[$begin$end]"
        $currentTime = "{0:G}" -f (get-date)
        # MySQL values
        $mysqlStamps = "('" + $hostname + "'," + $rawMemory + ",'" + $mysqlDate + "'),"
        Add-Content -Path $fileLoc -Value $mysqlStamps
        Start-Sleep 2
    }  
}
ElseIf ($global:choicemade -eq "Script stoppen") {
    # Exit script
    Write-Host "Je hebt ervoor gekozen om het script te stoppen."
    Write-Host "1...2...3..."
    Start-sleep -Seconds 3
    exit
}
Else {
    # Clear file
    Clear-Content -Path $fileLoc
    # MySQL use database
    Add-Content -Path $fileLoc -Value $mysqlDatabase
    # MySQL start inserting
    Add-Content -Path $fileLoc -Value $mysqlInsert
    # MySQL table selection
    Add-Content -Path $fileLoc -Value $mysqlTable
    # MySQL value selection
    Add-Content -Path $fileLoc -Value $mysqlValues
    # Start generating 
    While ((Get-Date) -Lt $stopTime) {
        Clear-Host
        # Loading bar
        $timeLeft = $stopTime - (Get-Date)
        $timePassed = ((($seconds - $timeLeft.Seconds) / $seconds) * 100)
        $reversePercent = ($timeLeft.Seconds / $seconds * 100)
        $end  = "-" *($reversePercent / 4)
        $begin = "0" *($timePassed / 4)
        $rawMemory = (Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory) -replace "[^0-9]" , ''
        $percMemory = "{0:n2}" -f ($rawMemory / 1000000) + "GB vrij"
        Write-Host "[$begin$end]"
        Write-Host "|>     "  $percMemory "     <|"
        Write-Host "[$begin$end]"
        $currentTime = "{0:G}" -f (get-date)
        # MySQL values
        $mysqlStamps = "('" + $hostname + "'," + $rawMemory + ",'" + $mysqlDate + "'),"
        Add-Content -Path $fileLoc -Value $mysqlStamps
        Start-Sleep 2
    }
}

# Clean empty lines
((Get-Content $fileLoc -Raw) -replace "(?m)^\s*`r`n",'').trim() | Set-Content $fileLoc

# Make correct query end ";"
$contentSql = (Get-Content $fileLoc)
$lastLine = $contentSql[-1]
$correctLine = ($lastLine.Substring(0,$lastLine.Length-1)) + ";"
(Get-Content $fileLoc).replace($lastLine, $correctLine) | Set-Content $fileLoc

# Done message
Clear-Host
Write-Host "[=========================]"
Write-Host "|>        Klaar...       <|"
Write-Host "[=========================]"
Start-Sleep 2

# Show file location
Clear-Host

# Choice: Open file location?
Write-Host "Locatie van het sql-bestand is: " $fileLoc
$global:choiceMade_Open = ""
While (($global:choiceMade_Open -ne "n") -and ($global:choiceMade_Open -ne "y")) {
        $global:choiceMade_Open = Read-Host "Wil je het bestand openen? (y or n)"
        Switch ($global:choiceMade_Open)
        { 
            "y" {$global:choiceMade = "opens"}
            "n" {$global:choiceMade = "End"}
        }
        
}
If ($global:choiceMade -eq "opens") {

    # Open
    notepad.exe $fileloc
}
Else{
    
    # Do not open
    Write-Host "Je koos ervoor om het tekstbestand niet te openen."
}

# Timestamp
$currentTime = "{0:G}" -f (get-date)
Write-Host "Script is afgerond om $currentTime"