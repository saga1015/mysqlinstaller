# Vars

# version specific vars
$mysqlVersion="8.0.15.0"
$goodHash="75fd5cd2676209550a8b9bac4fd0a8b6"
$downloadUrl="https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.15-winx64.zip"
$installFile="mysql-8.0.15-winx64.zip"
$unzippedversion="mysql-8.0.15-winx64"


# generic vars
$installedPath="C:\MySQL"
$downloadDirectory="C:\temp\installmysql\"
$downloadPath="$downloadDirectory$installFile"
$logPath=""
$expandDirectory="$downloadDirectory\expand\"
$unzippedDirectory="$expandDirectory\$unzippedversion"
$renamedDirectory="$expandDirectory\MySQL"

#
# Test Download Directory, make if not present
#
If(!(Test-Path $downloadDirectory))
{
      New-Item -ItemType Directory -Force -Path $downloadDirectory
}  

#
# Allows TLS1.2, Powershell default for Invoke-WebRequest is 1.0 
#
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#
#Download installer
#
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath
$downloadHash=(Get-FileHash -Algorithm md5 $downloadPath).Hash

#
#Unzip and move to correct path if download matches correct hash
#

if (!($downloadHash -eq $goodHash))
  {
    Write-Host "*************`nChecksum does not match!`n*************`nCheck file integrity and software version`n*************"
    exit
  }

  
# Test Expand Directory, make if not present
If (!(Test-Path $expandDirectory))
    {
    New-Item -ItemType Directory -Force -Path $expandDirectory
    }

#Unzip to correct location
Expand-Archive $downloadPath -DestinationPath $expandDirectory

#Rename directory
Rename-Item $unzippedDirectory $renamedDirectory

#Move unzipped directory
Copy-Item -Path $renamedDirectory -Destination C:\ -Force -recurse

#Clearup
Remove-Item -path $downloadDirectory -recurse
    

# Add MySQL to Path
$env:path += ";C:\MySQL\bin"
setx PATH $env:path /M

# creates data folder

mkdir $installedPath\data