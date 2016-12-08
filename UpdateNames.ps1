<# 
	1. Take copy of project and dump this script in that folder.
	2. Change the newName parameter to the new NEWPROJECTNAME
	3. Change the currentName to the old OLDPROJECTNAME
	4. Open CMD and CD to to the project folder eg: C:\GitHub\OLDPROJECTNAME
	5. Run this script with the following command powershell -file .\UpdateNames.ps1
#>

$newName = "NEWPROJECTNAME" 
$currentName = "OLDPROJECTNAME"

function Main()
{
    Write-Host "Start"
    Write-Host ("Renaming : " + $currentName + " to :  " + $newName ) -ForegroundColor Yellow

    $files = get-childitem . *.cs* -rec
    $files += get-childitem . *.config -rec
    $files += get-childitem . *.sln -rec
    $files += get-childitem . *.asax.cs -rec
    $files += get-childitem . *.pubxml* -rec
    $files += get-childitem . *.json -rec
    $files += get-childitem . *.asax.cs -rec
    $files += get-childitem . *.asax -rec
    $files += get-childitem . *.txt -rec

    foreach ($file in $files)
    {
        (Get-Content $file.PSPath) | % {
            $_ -replace $currentName, $newName
            } |  Set-Content $file.PSPath
    }
    Get-ChildItem bin -Recurse | % { 
        Write-Host "Removing bin folder"
        Remove-Item $_ -Force -Recurse 
    }
    Get-ChildItem obj -Recurse | % { 
        Write-Host "Removing obj folder"
        Remove-Item $_ -Force -Recurse 
    }
    Get-ChildItem -Filter *$currentName* -Recurse | Rename-Item -NewName {
        Write-Host ("Update name on " + $_.name)
        $_.name -replace $currentName,$newName 
    }
    Write-Host "You have to manually rename the main folder if you have not done that already." 
    Write-Host "Done, Thank you" -ForegroundColor green
}
Main
Pause
