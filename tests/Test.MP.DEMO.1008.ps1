function Test-DemoLongRunning {
    <#
    .SYNOPSIS
    A long-running test that shows live output and progress in the console, and embeds an HTML report.

    .DESCRIPTION
    Runs for about 20 seconds through three made-up stages. It writes log lines with Write-MtTestOutput,
    shows the stage, the items done, the items running and an error with Write-MtTestProgress, and then
    attaches a small HTML report with Add-MtReportAttachment. Run it with -IncludeLongRunning, or with
    -Pack DEMO, which runs a named pack's long-running tests.
    #>
    [MaesterTest(
        Id          = 'MP.DEMO.1008',
        Title       = 'Demo: a long-running test with live progress and a report',
        Severity    = 'Info',
        LongRunning = $true
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $stages = 'Collecting', 'Checking', 'Writing the report'
    $items = 'Users', 'Groups', 'Devices', 'Applications', 'Policies', 'Sites'
    $finished = [System.Collections.Generic.List[object]]::new()
    $failed = 0

    Write-MtTestOutput -Title 'Demo pack: long-running test'
    for ($stageNumber = 1; $stageNumber -le 2; $stageNumber++) {
        $stage = $stages[$stageNumber - 1]
        $finished.Clear()
        $failed = 0
        Write-MtTestOutput "Starting stage $stageNumber of $($stages.Count): $stage"
        for ($i = 0; $i -lt $items.Count; $i++) {
            $item = $items[$i]
            $running = @(@{ Id = $item; Title = "$stage $item"; Status = 'Running'; Detail = 'Reading page 1'; Seconds = 0 })
            Write-MtTestProgress -Stage $stage -StageNumber $stageNumber -StageCount $stages.Count -Stages $stages `
                -Completed ($i - $failed) -Failed $failed -Total $items.Count -Running 1 -Current $item `
                -Items (@($running) + @($finished))
            Write-MtTestOutput "$stage ${item}..."
            Start-Sleep -Milliseconds 1500
            if ($stageNumber -eq 1 -and $item -eq 'Devices') {
                $failed++
                Write-MtTestProgress -ErrorMessage "$stage $item failed: this demo error is on purpose."
                $finished.Insert(0, @{ Id = $item; Title = "$stage $item"; Status = 'Failed'; Detail = 'Demo error'; Seconds = 1.5 })
            } else {
                Write-MtTestOutput "$stage ${item}: done"
                $finished.Insert(0, @{ Id = $item; Title = "$stage $item"; Status = 'Passed'; Seconds = 1.5 })
            }
        }
    }

    Write-MtTestProgress -Stage $stages[2] -StageNumber 3 -StageCount $stages.Count -Stages $stages -Completed 0 -Total 1 -Running 1 -Current 'Report'
    Write-MtTestOutput 'Writing the HTML report'
    $rows = ($items | ForEach-Object { "<tr><td>$_</td><td>$(if ($_ -eq 'Devices') { 'Failed' } else { 'Passed' })</td></tr>" }) -join ''
    $html = @"
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Demo pack report</title>
<style>
body { font-family: system-ui, sans-serif; margin: 2rem; color: #1f2937; }
table { border-collapse: collapse; } td, th { border: 1px solid #d1d5db; padding: .4rem .8rem; text-align: left; }
button { margin-top: 1rem; padding: .4rem .8rem; }
</style></head>
<body>
<h1>Demo pack report</h1>
<p>Written by MP.DEMO.1008 at $([datetime]::UtcNow.ToString('u')). It shows how a pack embeds another tool's HTML report.</p>
<table><tr><th>Item</th><th>Result</th></tr>$rows</table>
<button onclick="this.textContent = 'Scripts run in the sandboxed frame'">Click to run a script</button>
</body></html>
"@
    Add-MtReportAttachment -Name 'Demo pack report' -Content $html
    Write-MtTestOutput -Complete

    Add-MtTestResultDetail -Result "Collected and checked $($items.Count) items; one failed on purpose. Open **Demo pack report** under Reports in the left menu."
    $true
}
