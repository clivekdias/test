Add-Type -AssemblyName System.Web
Add-Type -AssemblyName System.IO.Compression.FileSystem
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"

function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$dirtemp = "C:\temp"
if(!(Test-Path -Path $dirtemp )){
    New-Item -Path $dirtemp -ItemType Directory
}
$dirtool = "C:\tool"
if(!(Test-Path -Path $dirtool )){
    New-Item -Path $dirtool -ItemType Directory
}


#[System.IO.Compression.ZipFile]::CreateDirectory("c:\temp")
#[System.IO.Compression.ZipFile]::CreateDirectory("c:\tool")

Write-Host "Installing Java"

$URL=(Invoke-WebRequest -UseBasicParsing https://www.java.com/en/download/manual.jsp).Content | %{[regex]::matches($_, '(?:<a title="Download Java software for Windows Online" href=")(.*)(?:">)').Groups[1].Value}
Invoke-WebRequest -UseBasicParsing -OutFile 'c:\temp\jre8.exe' $URL
Start-Process 'c:\temp\jre8.exe' '/s REBOOT=0 SPONSORS=0 AUTO_UPDATE=0' -wait
echo $?

Write-Host "Installing Java finished"



Remove-Item -Recurse -Force "C:\tool"
Write-Host "Downloading Jmeter"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("http://apache.mirror.amaze.com.au/jmeter/binaries/apache-jmeter-5.1.1.zip","C:\temp\apache-jmeter-5.1.1.zip")

Write-Host "Installing Jmeter"
Unzip "C:\temp\apache-jmeter-5.1.1.zip"  "C:\tool"

Write-Host "Installing Jmeter finished"