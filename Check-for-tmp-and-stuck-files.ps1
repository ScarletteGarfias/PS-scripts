Invoke-Command -ComputerName ServerName -ScriptBlock {

$FromAddress = "PS-Script@email.com"
$ToAddress = "user@email"
$SmtpServer="smtp.com"

$RampInput = "C:\RampInput"
$TmpFiles = "C:\TmpFiles"

$TmpCount = (Get-ChildItem -Path $RampInput -File -filter *.tmp| Measure-Object).Count


if ($TmpCount -gt 0)
    {
        $TempMsg = "Temp file(s) moved: " + $TmpCount
        try{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files' -SmtpServer $SmtpServer -Body $TempMsg
            Write-Host "TEMP EMAIL SENT"
        }
        catch {
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MAIL' -SmtpServer $SmtpServer -Body "There was an error processing .tmp alert"
            Write-Host "ERROR TEMP EMAIL"
        }

        Move-Item -Path $RampInput\*.tmp -Destination $TmpFiles
    }
else 
    {
        Write-Host "There are no temp files."
    }


$StuckCOunt = (Get-ChildItem -Path $RampInput -file | where {$_.Lastwritetime -lt (date).addminutes(-30)} | Measure-Object).Count

if ($StuckCount -gt 0)
    {
        $StuckMsg = "Stuck File(s):" + $StuckCOunt
        TRY{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'Stuck Files' -SmtpServer $SmtpServer -Body $StuckMsg
            Write-Host "STUCK EMAIL SENT"
        }
        Catch{
            Send-MailMessage -From $FromAddress -To $ToAddress -Subject 'TMP Files ERROR MAIL' -SmtpServer $SmtpServer -Body "There was an error processing stuck alert."
            Write-Host "ERROR STUCK EMAIL"
            }

    }
}
