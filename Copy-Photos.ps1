#
# The script scans a source directory of .jpg files, gets DateTaken date value, makes a new file name in format yyyyMMdd-HHmmss.jpg
# and copies the file to destination directory.
#

param (
    [string]$SourceDir = "",
    [string]$DestinationDir = ""
)

[reflection.assembly]::LoadFile("C:\Windows\Microsoft.NET\Framework\v4.0.30319\System.Drawing.dll") 

$photos = Get-ChildItem -Path "$SourceDir\*.jpg" | Select-Object -Property FullName, Name, BaseName, Extension

Write-Host $photos.Count " photos found on " $SourceDir

foreach ($p in $photos) {
    $img = New-Object System.Drawing.Bitmap($p.FullName)
    
    Write-Host ($photos.IndexOf($p) + 1) "/" ($photos.Count) ": " $p.FullName
    try
    {
        $prop = $img.GetPropertyItem(36867).Value
        [string]$dateString = [System.Text.Encoding]::ASCII.GetString($prop)
        [string]$dateTaken = [datetime]::ParseExact($dateString,"yyyy:MM:dd HH:mm:ss`0",$Null).ToString('yyyyMMdd-HHmmss')
        $newFileName = $dateTaken + ".jpg"
        
        Copy-Item -Path $p.FullName -Destination ($DestinationDir + $newFileName)
    }
    catch
    {
        Write-Host -ForegroundColor White -BackgroundColor Red "Unable to get property of the file $p"
    }

    $img.Dispose()
}