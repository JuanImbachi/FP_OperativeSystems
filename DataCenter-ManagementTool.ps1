<#
.SYNOPSIS
DataCenter-ManagementTool provides important information from your data center, so you can easily manage it
.DESCRIPTION
DataCenter-ManagementTool provides the following instructions:
1. Top 5 process consuming CPU: Shows all information about the top five processes that use CPU, using the cmdlet get-process
2. Show filesystems or disk connected: Uses Get-WmiObject to retrieve the instances of Win32_LogicalDisk from the computer. Displays name, free space and size
3. Biggest file on disk or filesystem: According with the path given, using Get-ChildItem it will do a recursive search to find the biggest file
4. Free memory space and swap space in use: Using systeminfo the state of the virtual and physical memories are displayed
5. Number of established connections: Using Get-NetTCPConnection it counts the number of connections with status "ESTABLISHED"
.EXAMPLE
.\DataCenter-ManagementTool.ps1

The Management option menu will display:
================ Management Options ================

1: Top 5 process using CPU.

2: Show filesystems or disks connected.

3: Biggest file on disk or filesystem.

4: Free memory space and Swap space in use.

5: Number of established connections

Q: Press 'Q' to quit.

Please make a selection: 

#>
function Show-Menu
{
    Clear-Host
    Write-Host "================ Management Options ================"
    Write-Host 
    Write-Host "1: Top 5 process using CPU."
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
    Write-Host "Calculating Results..."
    Write-Host
    $totalPhysicalMemory = systeminfo | select-string "Cantidad total de memoria f¡sica:"
    $totalPhysicalMemoryNumber = [double][regex]::Matches($totalPhysicalMemory, '[\d.]+').Value -replace "\,",""
    $totalPhysicalMemoryBytes = [double] $totalPhysicalMemoryNumber * 1000000


    $physicalMemoryAvailable = systeminfo | select-string "Memoria f¡sica disponible:"
    $physicalMemoryAvailableNumber = [double][regex]::Matches($physicalMemoryAvailable, '[\d.]+').Value -replace "\,",""
    $physicalMemoryAvailableBytes = [double] $physicalMemoryAvailableNumber * 1000000

    $virtualMemoryInUse = systeminfo | select-string "Memoria virtual: en uso:"
    $virtualMemoryInUseNumber = [double][regex]::Matches($virtualMemoryInUse, '[\d.]+').Value -replace "\,",""
    $virtualMemoryInUseBytes = [double] $virtualMemoryInUseNumber * 1000000


    $totalVirtualMemory = systeminfo | select-string "Memoria virtual: tama¤o m ximo:"
    $totalVirtualMemoryNumber = [double][regex]::Matches($totalVirtualMemory, '[\d.]+').Value -replace "\,",""
    $totalVirtualMemoryBytes = [double] $totalVirtualMemoryNumber * 1000000

    Write-Host "Swap in use (bytes):            " $virtualMemoryInUseBytes
    Write-Host "Swap in use (%):                " (($virtualMemoryInUseBytes / $totalVirtualMemoryBytes) * 100) "%"
    Write-Host "Physical Memory in use (bytes): " $physicalMemoryAvailableBytes
    Write-Host "Physical Memory in use (%):     " (($physicalMemoryAvailableBytes / $totalPhysicalMemoryBytes) * 100) "%"
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