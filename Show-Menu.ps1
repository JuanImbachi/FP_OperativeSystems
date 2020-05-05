<#
.SYNOPSIS
.DESCRIPTION
.EXAMPLE
#>
function Show-Menu
{
    Clear-Host
    Write-Host "================ Options ================"
    Write-Host 
    Write-Host "1: Top 5 process consuming CPU."
    Write-Host
    Write-Host "2: Show filesystems or disks connected."
    Write-Host
    Write-Host "3: Biggest file on disk or filesystem."
    Write-Host
    Write-Host "4: Free memory space and Swap space in use."
    Write-Host
    Write-Host "5: Number of established connections"
    Write-Host
    Write-Host "Q: Press 'Q' to quit."
    Write-Host
}

function First-Option
{
    Get-Process | sort -descending CPU | select -First 5
}

function Second-Option
{

    Get-WmiObject -Class win32_logicaldisk | ft @{n='Name';e={$_.Name}}, @{n='Free Space (bytes)';e={$_.FreeSpace }}, @{n='Size (bytes)';e={$_.Size }}
}

function Third-Option
{
  $path = Read-Host "Please,insert the path of the disk or filesystem"
  
  Get-ChildItem -Path $path -Recurse | sort -Descending Length | select -First 1| ft @{n='Name';e={$_.Name}},  @{n='Path';e={$_.FullName}}, @{n='Size (bytes)';e={$_.Length}} -wrap -autosize
}

function Fourth-Option
{
  Get-ChildItem -Path "C:/" -Hidden
  #Preguntar sobre archivos swap page and hiber file, preguntar sobre que memoria se busca el espacio libre
}

function Fifth-Option
{
  Get-NetTCPConnection -State Established | Measure-Object -Line | ft @{n='Established Connections';e={$_.Lines}} 
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
                Fourth-Option
             } 

         '5' {
                Fifth-Option
             }
     }
     pause
 }
 until ($selection -eq 'q')