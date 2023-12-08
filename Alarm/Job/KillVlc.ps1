$vlcProcesses = @(Get-Process -Name vlc)

foreach($y in $vlcProcesses){ Stop-Process -Id $y.Id}