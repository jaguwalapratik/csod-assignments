[CmdletBinding(SupportsShouldProcess=$true)]
param
(
[Parameter(ValueFromPipeline=$true,
ValueFromPipelineByPropertyName=$true,
Mandatory=$true,
HelpMessage="Please enter dump file name")]
[Alias('FileName')]
[string]$File
)

#$line = Select-String -Pattern '(?<=Thread)(.*)(?=Time)' -Path $File.BasicAnalysis.txt.log

Get-ChildItem -Path $File | Get-DumpAnalysis -DebuggingScript .BasicAnalysis.txt

$start_line = Select-String -Pattern 'Listing all runaway threads started' -Path $File-.BasicAnalysis.txt.log

$end_line = Select-String -Pattern 'Listing all runaway threads finished' -Path $File-.BasicAnalysis.txt.log

$thread_list = Get-Content -Path $File-.BasicAnalysis.txt.log | Select -Index (($start_line.LineNumber + 3)..($end_line.LineNumber - 2)) | ConvertFrom-String -propertynames blank,p1,p2,p3,p4 | Select * -ExcludeProperty blank


Write-Output "Long running thread id"
Write-Output "----------------------"
$thread_list[0].p1