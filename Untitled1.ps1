#IP, HostName, OpenPorts, Notes
#Array of all the xml files
$files = (Get-ChildItem -Path "C:\Users\byrdb\Documents\Nmapscan\*.xml").FullName
#Write-Host($files)


$hostData = ($hostData = " " | Select-Object HostName, IPV4, Ports)
$xmldoc = New-Object System.Xml.XmlDocument
$xmldoc.Load($files)
foreach($hostnode in $xmldoc.nmaprun.host)
{
    if($hostnode.Status.State -eq "Down")
    {
        continue
    }
    else
    {
       $tempHostName = ""
       foreach ($hostname in $hostnode.hostnames)
       {
            foreach ($hname in $hostname.hostname)
            {
                foreach ($namer in $hname.name)
                {
                    if ($namer -ne $null -and $namer.length -ne 0)
                    {
                            #Only append to temp variable if it would be unique.
                        if($tempHostName.IndexOf($namer.tolower()) -eq -1)
                            { $tempHostName = $tempHostName + " " + $namer.tolower() } 
                    }
                }
            }
       }
       $tempHostName = $tempHostName.Trim()
       if ($tempHostName.Length -eq 0 -and $tempFQDN.Length -eq 0) { $tempHostName = "<no-hostname>" } 

       $hostData.HostName = $tempHostName

       foreach($addr in $hostnode.address)
       {
            if($addr.addrtype -eq "ipv4") {$hostData.IPV4 += $addr.addr + ","}
       }
       if($hostData.IPV4 -eq $null) {$hostData.IPV4 = "<no-ipv4>"} else {$hostData.IPV4 = $hostData.IPV4.Trim()}

       if ($hostnode.ports.port -eq $null) { $hostData.Ports = "<no-ports>"}
       else {
            foreach($porto in $hostnode.ports.port)
            {
                if($proto.state.state -like "open")
                {
                    $hostData.Ports += $porto.portid + ","
                }
            }
            $hostData.Ports = $hostData.Ports.Trim()
       }
    }
}

Write-Host($hostData.IPV4)
Write-Host($hostData.HostName)
Write-Host($hostData.Ports)