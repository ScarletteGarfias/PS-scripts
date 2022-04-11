Invoke-Command -ComputerName ServerName -ScriptBlock {

$FromAddress = "PS-Script@email.com"
$ToAddress = "user@email"
$SmtpServer="smtp.com"

$RampInput = "C:\RampInput"
$TmpFiles = "C:\TmpFiles"

$TmpCount = (Get-ChildItem -Path $RampInput -File -filter *.tmp| Measure-Object).Count

#CHECKS .TMP FILES IN RAMPINPUT

if ($TmpCount -gt 0)
    {
        $TempMsg = "Temp file(s) moved: " + $TmpCount
        try{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'Temp Files in RampInput' -SmtpServer $SmtpServer -Body $TempMsg
            #Write-Host "TEMP EMAIL SENT"
        }
        catch {
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MAIL' -SmtpServer $SmtpServer -Body "There was an error processing .tmp alert."
            #Write-Host "ERROR TEMP EMAIL"
        }
        try{
            Move-Item -Path $RampInput\*.tmp -Destination $TmpFiles
        }
        catch{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MOVING' -SmtpServer $SmtpServer -Body "There was an error mvoing temp files."
        }  
    }
else 
    {
        Write-Host "There are no temp files."
    }

#CHECKS ALL FILES OLDER THAN 30MIN IN RAMPINPUT

$StuckCOunt = (Get-ChildItem -Path $RampInput -file | where {$_.Lastwritetime -lt (date).addminutes(-30)} | Measure-Object).Count

if ($StuckCount -gt 0)
    {
        $StuckMsg = "Stuck File(s):" + $StuckCOunt
        TRY{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'Stuck Files in RampInput' -SmtpServer $SmtpServer -Body $StuckMsg
            #Write-Host "STUCK EMAIL SENT"
        }
        Catch{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MAIL' -SmtpServer $SmtpServer -Body "There was an error processing stuck alert."
            #Write-Host "ERROR STUCK EMAIL"
            }

    }
else
    {
        Write-Host "There are no stuck files."
    }
}
