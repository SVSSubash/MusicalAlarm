# Script to setup an automatic alarm clock, that will play the specified music at that time. The musics sound will increment slowly over a period of time rather than a single volume at the start.
# owner: susikhar

$AlarmSettingsFile = "D:\Source\Alarm\Data\AlarmSettings.txt"

function Set-Alarm
{
    param(

        [Parameter(Mandatory=$true)]
        [int]$AlarmHour,

        [Parameter(Mandatory=$false)]
        [int]$Minute
    )

    if($AlarmHour -lt 0 -or $AlarmHour -ge 24)
    {
        Write-Host "[Set-Alarm]: Please specify a valid Hour. Error!" -ForegroundColor Red

        return
    }

    if($Minute -gt 60 -or $Minute -lt 0)
    {
        Write-Host "[Set-Alarm]: Please specify a valid Minute. Error!" -ForegroundColor Red

        return
    }

    Write-Host "[Set-Alarm]: Starting set alarm function."

    "Hour:" + $AlarmHour > $AlarmSettingsFile

    "Minute:" + $Minute >> $AlarmSettingsFile

    Write-Host "[Set-Alarm]: Done Setting alarm time." -ForegroundColor Green
}

Write-Host "[Set-Alaram]: Function loaded." -ForegroundColor Green