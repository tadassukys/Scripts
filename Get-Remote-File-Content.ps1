#
# The script reads remote file (via http[s] or ftp[s]) and sends the content to "output stream"
# Usage example: 
# .\Get-Remote-File-Content.ps1 -RemoteFileUrl ftp://ftp.gnu.org/pub/gnu/emacs/windows/README
# .\Get-Remote-File-Content.ps1 -RemoteFileUrl https://www.gnu.org/licenses/gpl-3.0.txt | more
#

param (
    [string]$RemoteFileUrl = "",
    [string]$UserName = "",
    [string]$Password = ""
)

if (!$Password -and $UserName -and $UserName.ToUpperInvariant() -ne "ANONYMOUS") {
    $response = Read-host "Enter the password:" -AsSecureString 
    $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))
}

$tempFilePath = $env:TEMP + "\" +[guid]::NewGuid()

$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($UserName,$Password)
$webClient.DownloadFile($RemoteFileUrl, $tempFilePath)

Get-Content $tempFilePath | Write-Output

Remove-Item $tempFilePath