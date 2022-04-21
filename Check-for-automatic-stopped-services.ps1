
$ServerName = "server1","Server2"

foreach ($Computer in $ServerName) {

    if (Test-Connection -Count 1 $Computer -Quiet -ErrorAction SilentlyContinue) 
    {
        Write-Host "Connection Found to Server:" $Computer

        try{
                #Get-Service -ComputerName $Computer -Exclude "RemoteRegistry","ShellHWDetection"| where{($_.StartType -eq "Automatic") -and ($_.Status -eq "Stopped")} | Select  MachineName, Name, Status

                $StoppedAutoServ = Get-Service -ComputerName $Computer -Exclude "ServiceName"| where{($_.StartType -eq "Automatic") -and ($_.Status -eq "Stopped")} | Select MachineName, Name, Status
                $SASCount = (Get-Service -ComputerName $Computer -Exclude "ServiceName" | where{($_.StartType -eq "Automatic") -and ($_.Status -eq "Stopped")} | Measure-Object).Count
                
                    if ($SASCount -gt 0)
                        {

                        #CREATE HTML TABLE1
                    $HtmlTable1 = "<table border='1' align='Left' cellpadding='10' cellspacing='2' style='color:black;font-family:arial,helvetica,sans-serif;text-align:left;'>
                        <tr style ='font-size:13px;font-weight: normal;background: #FFFFFF'>
                            <th align=left><b>Service(s)</b></th>
                        </tr>"

                        #INSERT INTO TABLE1
                    foreach ($Name in $StoppedAutoServ)
                        { 
                            $HtmlTable1 += "<tr style='font-size:13px;background-color:#FFFFFF'>
                                <td>" + $Name + "</td> </tr>"
                        }
                       
$FromAddress = "email@email.com"
$ToAddress = "user@email.com"
$SmtpServer="smtp.com"

                        $MsgBody = "The following services have stopped:" + $HtmlTable1
                            try{
                                Send-MailMessage -From $FromAddress -To $ToAddress -Subject "Automatic Services Stopped on Server" -SmtpServer $SmtpServer -Body $MsgBody -BodyAsHtml
                                }
                            catch {
                                Send-MailMessage -From $FromAddress -To $ToAddress -Subject "Automatic Services ERROR" -SmtpServer $SmtpServer -Body "There was an error emailing the services."
                                }
                        }
                    else
                        {
                            Write-Host "All automatic services are running."
                        }
            }
        catch{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'Automatic Services ERROR' -SmtpServer $SmtpServer -Body "Could not get services."
            Write-Host "Could not get services."
            }
    }
else 
    {
        Send-MailMessage -From $FromAddress -To $ToAddress -Subject "SERVER IS OFFLINE" -SmtpServer $SmtpServer -Body "SERVER IS OFFLINE."
        Write-Host "Server is offline:" $Computer
    }
    }
