
$triggerDir = "$env:USERPROFILE\OneDrive - Hong Kong Education City Limited\EdCity\Misc\AlertTrigger"
$processedDir = "$triggerDir\processed"

if (!(Test-Path $processedDir)) {
    New-Item -ItemType Directory -Path $processedDir | Out-Null
}

$files = Get-ChildItem $triggerDir -Filter *.txt -File | Sort-Object LastWriteTime

foreach ($file in $files) {

    $content = Get-Content $file.FullName -Raw

    $content = Convert-TimestampToGMT8 -InputText $content

    powershell.exe -ExecutionPolicy Bypass -File "C:\Users\bronson.so\Documents\EdCity\Useful Documents\Scripts\Common\PersistentPopup.ps1" `
        -Title "Important Mail (Zendesk Support)" `
        -Message $content

    Move-Item $file.FullName -Destination $processedDir -Force
}
# ******************************** * COMMON FUNCTIONS * ********************************

# * Function to Convert Timestamp to GMT+8 *
function Convert-TimestampToGMT8 {
    param(
        [string]$InputText
    )
    
    $convertedText = [regex]::Replace($InputText, 'Received:\s*([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\+[0-9]{2}:[0-9]{2})', {
        param($match)
        
        $timestampString = $match.Groups[1].Value
        $utcTime = [DateTimeOffset]::Parse($timestampString)
        $gmtPlus8Time = $utcTime.ToOffset([TimeSpan]::FromHours(8))
        $formattedTime = $gmtPlus8Time.ToString("yyyy-MM-dd HH:mm:ss 'GMT+8'")
        
        return "Received: $formattedTime"
    })
    
    return $convertedText
}