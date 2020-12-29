$max_jobs = 8 
$tstart = get-date
$src = "D:\"
$dest = "Y:\"
$log = "c:\robo\Logs\"
mkdir $log
$files = ls $src
$files | %{
$ScriptBlock = {
param($name, $src, $dest, $log)
$log += "\$name-$(get-date -f yyyy-MM-dd-mm-ss).log"
robocopy $src$name $dest$name  /mir /E /Z /ZB /R:5 /W:5 /TBD /copy:DT /MT:20> $log
Write-Host $src$name " completed"
 }
$j = Get-Job -State "Running"
while ($j.count -ge $max_jobs) 
{
 Start-Sleep -Milliseconds 500
 $j = Get-Job -State "Running"
}
 Get-job -State "Completed" | Receive-job
 Remove-job -State "Completed"
Start-Job $ScriptBlock -ArgumentList $_,$src,$dest,$log
 }
While (Get-Job -State "Running") { Start-Sleep 2 }
Remove-Job -State "Completed" 
  Get-Job | Write-host

$tend = get-date

new-timespan -start $tstart -end $tend
