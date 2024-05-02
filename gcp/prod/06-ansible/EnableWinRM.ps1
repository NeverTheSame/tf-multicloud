# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
$url = "<https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1>"
$file = "$env:temp\\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file

Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
New-ItemProperty -Name LocalAccountTokenFilterPolicy -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -PropertyType DWord -Value 1

$cert = New-SelfSignedCertificate -DnsName "serverXXXHelper" -CertStoreLocation Cert:\LocalMachine\My
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"serverXXXHelper`"; CertificateThumbprint=`"$($cert.Thumbprint)`"}"