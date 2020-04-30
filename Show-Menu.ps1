function Show-Menu
{
    param (
        [string]$Title = 'Options'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Top 5 process consuming CPU."
    Write-Host "2: Show filesystems or disks connected."
    Write-Host "3: Biggest file on disk or filesystem."
    Write-Host "4: Press '4' for this option."
    Write-Host "5: Press '5' for this option."
    Write-Host "Q: Press 'Q' to quit."
}

function First-Option
{
    Get-Process | sort -descending CPU | select -First 5
}

function Second-Option
{

    Get-WmiObject -Class win32_logicaldisk | ft @{n='Nombre';e={$_.Name}}, @{n='Espacio Libre (bytes)';e={$_.FreeSpace }}, @{n='Tamaño (bytes)';e={$_.Size }}
}

function Third-Option
{
  $path = Read-Host "Please,insert the path of the disk or filesystem"
  
  Write-Host $path
}

do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' {
                First-Option
             } 

         '2' {
                Second-Option
             } 

         '3' {                  
                Third-Option

             } 

         '4' {
                'You chose option #4'
             } 

         '5' {
                'You chose option #5'
             }
     }
     pause
 }
 until ($selection -eq 'q')