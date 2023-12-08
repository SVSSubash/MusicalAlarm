# Script to run an alarm clock, that will play the specified music at that time. The musics sound will increment slowly over a period of time rather than a single volume at the start.
# owner: susikhar

. D:\Source\Alarm\Library\AudioControl.ps1

"Start $(Get-Date)" >> d:\Source\Alarm\Log.txt

$MusicFolder = "D:\Music"

$AlarmSettingsFile = "D:\Source\Alarm\Data\AlarmSettings.txt"

function Play-Music
{
    param(

    [Parameter(Mandatory=$false)]
    [switch]$RandomMusic=$true

    )

    if((Test-Path -Path $MusicFolder) -eq $False)
    {
        Write-Host "[Play-Music]: Cant play music as there is no music specified to play. Error!" -ForegroundColor Red

        return
    }

    $MusicFolder = Get-ChildItem -Path $MusicFolder

    if($MusicFolder.Length -eq $null -or $MusicFolder.Length -eq 0)
    {
        Write-Host "[Play-Music]: Cant play music as there is no music in the folder specified to play. Error!" -ForegroundColor Red

        return
    }

    Write-Host "[Play-Music]: Starting to play the first music found." -ForegroundColor Green

    if($RandomMusic)
    {
        $MusicFolder = $MusicFolder | Sort-Object {Get-Random}
    }

    Invoke-Item -Path "$($MusicFolder[0].FullName)"
}


[Console]::SetCursorPosition(0,[Console]::CursorTop)
function Start-Alarm
{
    Write-Host "[Start-Alarm]: Starting startAlarm function probe." -ForegroundColor Green

    $AlarmSettings = Get-Content -Path $AlarmSettingsFile

    $Loop = $true

    do
    {
        Write-Host "[Start-Alarm]: Checking time." -ForegroundColor Yellow -NoNewLine

        [Console]::SetCursorPosition(0,[Console]::CursorTop)

        $CurrentDate = Get-Date

        if(($AlarmSettings[0]).Remove(0,5) -eq $CurrentDate.Hour -and $CurrentDate.Minute -ge ($AlarmSettings[1]).Remove(0,4))
        {
            # Write-Host "[Start-Alarm]: Time is expected time found it." -ForegroundColor Green

            Play-Music

            $Loop = $false
        }
        else
        {
            Write-Host "[Start-Alarm]: Time is not ready yet." -ForegroundColor Magenta -NoNewLine

            [Console]::SetCursorPosition(0,[Console]::CursorTop)
        }

    }while($Loop)
}

function Control-VolumeFlow
{
    param(

        [Parameter(Mandatory=$false)]
        [int]$VolumeGraduationTimeLimitInMinutes = 8,

        [Parameter(Mandatory=$False)]
        [int]$IncrementPercentage=1,

        [switch]$UseIncrementPercentage=$true

    )

    Write-Host "[Control-VolumeFlow]: Starting control flow of the system volume." -ForegroundColor Yellow

    $VolumeIncrementLevels = 0

    if(-not $UseIncrementPercentage)
    {
        $VolumeIncrementLevels = 100 / $VolumeGraduationTimeLimitInMinutes
    }
    else
    {
        $VolumeIncrementLevels = $IncrementPercentage
    }

        Write-Host "[Control-VolumeFlow]: Incrementing volume in VolumeIncrementLevels=[$VolumeIncrementLevels]."

        [audio]::Mute = $false

        [audio]::Volume = .01

        $MultiplesOf5Volume=@(0.05,0.1,0.15,0.20,0.25)

        do
        {
            if($MultiplesOf5Volume.Contains([audio]::Volume))
            {
                Start-Sleep -Seconds 300
            }
            else
            {
                Start-Sleep -Seconds 30
            }

            [audio]::Volume = [audio]::Volume + ($VolumeIncrementLevels/100)

        }
        while([audio]::Volume -le .30)
}

# Starting main body.

# Write-Host "[RunAlarmClock]: Setting the volume of the speakers to mute." -ForegroundColor Yellow

[Console]::Write("start");

[Audio]::Mute = $true

[Audio]::Volume = 0

# Write-Host "[RunAlarmClock]: Checking if the alarm should run yet." -ForegroundColor Yellow

Start-Alarm

# Write-Host "[RunAlarmClock]: Starting control of volume of music to a gradual increase." -ForegroundColor Yellow

Control-VolumeFlow -UseIncrementPercentage:$false

"End $(Get-Date)" >> d:\Source\Alarm\Log.txt


