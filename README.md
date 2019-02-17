# Simple MYSQL Community installer for Windows Server

### About

A simple powershell script to handle installation of the web for the Community edition of MYSQL to a Windows Server.
This script uses the web installer, not the full installer.
This script currently installs version 8.0.15.0 (latest at time for writing)

### This installer is for systems not using chocolatey

If you were using chocolately you could just run the following:
`choco install -y mysql`

### This script assumes the following prerequisties

1. User running the script can escalate privileges
2. Powervsion Version 5 - not tested in previous versions
3. Scipt is run locally on the target server
4. The target server has adequately permissive networking

### Actions

Currently this script carries out the following:
Downloads the -noinstaller version of MySQL Server Community 8.0.15.0 as an archive
Compares MD5 - exits on no match
Unzips the archive
Renames the unpacked folder
Copies the unpacked folder to C:\MySQL
Clears up temp download folder 
Adds mysql to path
creates data/ in the MySQL directory 

### Futher reading:
https://dev.mysql.com/downloads/mysql/
https://dev.mysql.com/doc/refman/8.0/en/windows-install-archive.html
https://blogs.technet.microsoft.com/canitpro/2016/10/18/step-by-step-installing-mysql-on-nano-server-via-powershell/
