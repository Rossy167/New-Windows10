# run this:
    # Set-ExecutionPolicy Unrestricted -Scope CurrentUser
    # .\setup.ps1


# do some updates while we're about

Install-PackageProvider NuGet 
Install-Module PSWindowsUpdate 
Get-WindowsUpdate -ForceDownload
Get-WindowsUpdate -ForceInstall

# debloat 

.\DebloatWin10.ps1
.\taskbar.bat

function Disable-Indexing {
    Param($Drive)
    $obj = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='$Drive'"
    $indexing = $obj.IndexingEnabled
    if("$indexing" -eq $True){
        write-host "Disabling indexing of drive $Drive"
        $obj | Set-WmiInstance -Arguments @{IndexingEnabled=$False} | Out-Null
    }
}

$drives = get-volume |select -ExpandProperty driveletter
$drives | ForEach-Object { Disable-Indexing $_":" }


# install all wanted packages (basically rebloat ngl)

.\InstallChoco.ps1

$packages = @('sysinternals', 'adobe', 'chromium', 'slack', 'dolphin', 'nmap', 'wireshark', 'franz', 'github-desktop', 'firefox', 'steam', 'vscode', 'javaruntime', 'jdk11', 'vlc', '7zip', 'qbittorrent', 'python', 'discord')

$packages | ForEach-Object {choco install $_ -y}

#Restart PC

Restart-Computer -Force