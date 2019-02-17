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
$dataPath="$installedPath\data"
$expandDirectory="$downloadDirectory\expand\"
$unzippedDirectory="$expandDirectory\$unzippedversion"
$renamedDirectory="$expandDirectory\MySQL"

#Start logging

Start-Transcript

#
# Test Download Directory, make if not present
#
Write-Host "Test Download Directory, make if not present"
If(!(Test-Path $downloadDirectory))
{
    Write-Host "Creating $downloadDirectory"
    New-Item -ItemType Directory -Force -Path $downloadDirectory
}
else
{
    Write-Host "$downloadDirectory already exists"
}

#
# Allows TLS1.2, Powershell default for Invoke-WebRequest is 1.0 
#
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#
#Download installer
#
Write-Host "Dowloading MySQL"
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath
Write-Host "Checking the hash"
$downloadHash=(Get-FileHash -Algorithm md5 $downloadPath).Hash

#
#Unzip and move to correct path if download matches correct hash
#

if (!($downloadHash -eq $goodHash))
  {
    Write-Host "*************`nChecksum does not match!`n*************`nCheck file integrity and software version`n*************"
    exit
  }
else
{
    Write-Host "Hashes match"
}

  
# Test Expand Directory, make if not present
Write-Host "Test Expand Directory, make if not present"
If (!(Test-Path $expandDirectory))
    {
    Write-Host "Making $expandDirectory"
    New-Item -ItemType Directory -Force -Path $expandDirectory
    }
else
{
    Write-Host "$expandDirectory already exists"
}

#Unzip to correct location
Write-Host "Unzipping MySQL"
Expand-Archive $downloadPath -DestinationPath $expandDirectory

#Rename and move upzipped directory

Write-Host "Moving unzipped folder"
Rename-Item $unzippedDirectory $renamedDirectory
Copy-Item -Path $renamedDirectory -Destination C:\ -Force -recurse

#Clearup
Write-Host "Clearing up after myself"
Remove-Item -path $downloadDirectory -recurse
    

# Check if MySQL is in path, add if missing

if($env:Path -like "*$installedPath\bin*") {
       Write-Host "$installedPath\bin already exists in Path statement" }
    else {
            Write-Host "Adding C:\MySQL\bin to path"
            $env:path += ";C:\MySQL\bin"
            setx PATH $env:path /M 
        }

# creates data folder
Write-host "Make $datapath"
mkdir $dataPath -Force

# Stops Transcript
Stop-Transcript