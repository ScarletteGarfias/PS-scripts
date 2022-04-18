Invoke-Command -ComputerName ServerName -ScriptBlock {

$FromAddress = "PS-Script@email.com"
$ToAddress = "user@email"
$SmtpServer="smtp.com"

$RampInput = "C:\RampInput"
$TmpFolder = "C:\TmpFiles"


#CREATE HTML TABLE1

$HtmlTable1 = "<table border='1' align='Left' cellpadding='10' cellspacing='2' style='color:black;font-family:arial,helvetica,sans-serif;text-align:left;'>
                    <tr style ='font-size:13px;font-weight: normal;background: #FFFFFF'>
                        <th align=left><b>File(s)</b></th>
                    </tr>"
# BEGIN SCRIPT(S)

  

#CHECKS .TMP FILES IN RAMPINPUT
$TmpFiles = Get-ChildItem -Path $RampInput -File -filter *.tmp

if ($Tmpfiles.Count -gt 0)    
{
  # Insert data into Table1
   foreach ($file in $TmpFiles)
      { 
        $HtmlTable1 += "<tr style='font-size:13px;background-color:#FFFFFF'>
        <td>" + $file + "</td> </tr>"
      }
      $TempMsg = "The follwoing tmp files were moved:<br/><br/>" + $HtmlTable1
        try{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'Temp Files in RampInput' -SmtpServer $SmtpServer -Body $TempMsg -BodyAsHtml
            Write-Host "TEMP EMAIL SENT"
        }
        catch {
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MAIL' -SmtpServer $SmtpServer -Body "There was an error processing .tmp alert."
            Write-Host "ERROR TEMP EMAIL"
        }
        try{
            Move-Item -Path $RampInput\*.tmp -Destination $TmpFolder
        }
        catch{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'ERROR MOVING FILES' -SmtpServer $SmtpServer -Body "There was an error mvoing .tmp files."
        }  
}
else 
    {
        Write-Host "There are no temp files."
    }

#CHECKS ALL FILES OLDER THAN 30MIN IN RAMPINPUT

$Stuckfiles = Get-ChildItem -Path $RampInput -file | where {$_.Lastwritetime -lt (date).addminutes(-30)} 

if ($Stuckfiles.Count -gt 0)
    {

    # Insert data into Table1
    foreach ($file in $Stuckfiles)
      { 
        $HtmlTable1 += "<tr style='font-size:13px;background-color:#FFFFFF'>
        <td>" + $file + "</td> </tr>"
      }
        $StuckMsg = "The follwoing files are stuck:<br/><br/>" + $HtmlTable1
        TRY{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'Stuck Files in RampInput' -SmtpServer $SmtpServer -Body $StuckMsg -BodyAsHtml
            Write-Host "STUCK EMAIL SENT"
        }
        Catch{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MAIL' -SmtpServer $SmtpServer -Body "There was an error processing stuck alert."
            Write-Host "ERROR STUCK EMAIL"
            }

    }
else
    {
        Write-Host "There are no stuck files."
    }
}
