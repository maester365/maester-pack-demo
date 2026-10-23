function Get-DemoReportHtml {
    <#
    .SYNOPSIS
    Returns the HTML report of MP.DEMO.1008: a single page, with its styles and script inline.

    .DESCRIPTION
    A report added with Add-MtReportAttachment opens inside the Maester report, in a sandboxed frame: its
    scripts run in an origin of their own, so they cannot read or change the Maester report. Keep the report
    to one file with its styles and scripts inline, so it works offline, and HTML-encode every value that
    comes from the tenant.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The checks to list, each with Id, Title, Area and Result.
        [Parameter(Mandatory)]
        [object[]] $Check
    )

    $rows = foreach ($c in $Check) {
        $cells = foreach ($value in $c.Id, $c.Title, $c.Area) { "<td>$([System.Net.WebUtility]::HtmlEncode([string]$value))</td>" }
        $result = [System.Net.WebUtility]::HtmlEncode([string]$c.Result)
        "<tr>$($cells -join '')<td><span class=""badge $($result.ToLowerInvariant())"">$result</span></td></tr>"
    }
    $passed = @($Check | Where-Object Result -EQ 'Passed').Count
    $failed = @($Check | Where-Object Result -EQ 'Failed').Count
    $investigate = @($Check | Where-Object Result -EQ 'Investigate').Count
    $generated = [datetime]::UtcNow.ToString('yyyy-MM-dd HH:mm', [System.Globalization.CultureInfo]::InvariantCulture)

    @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Demo pack report</title>
<style>
:root { --bg: #f8fafc; --card: #ffffff; --text: #0f172a; --muted: #64748b; --line: #e2e8f0; --pass: #16a34a; --fail: #dc2626; --inv: #9333ea; --accent: #2563eb; }
@media (prefers-color-scheme: dark) { :root { --bg: #0b1120; --card: #111827; --text: #e5e7eb; --muted: #94a3b8; --line: #1f2937; } }
* { box-sizing: border-box; }
body { margin: 0; font: 15px/1.5 system-ui, -apple-system, "Segoe UI", sans-serif; background: var(--bg); color: var(--text); }
main { max-width: 960px; margin: 0 auto; padding: 32px 20px; }
h1 { margin: 0 0 4px; font-size: 26px; }
.muted { color: var(--muted); }
.cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 12px; margin: 24px 0; }
.card { background: var(--card); border: 1px solid var(--line); border-radius: 10px; padding: 16px; }
.card b { display: block; font-size: 28px; }
.pass b { color: var(--pass); } .fail b { color: var(--fail); } .inv b { color: var(--inv); }
input { width: 100%; padding: 10px 12px; border: 1px solid var(--line); border-radius: 8px; background: var(--card); color: var(--text); font: inherit; margin-bottom: 12px; }
table { width: 100%; border-collapse: collapse; background: var(--card); border: 1px solid var(--line); border-radius: 10px; overflow: hidden; }
th, td { text-align: left; padding: 10px 12px; border-bottom: 1px solid var(--line); }
th { font-size: 13px; color: var(--muted); font-weight: 600; }
.badge { padding: 2px 8px; border-radius: 999px; font-size: 13px; color: #fff; }
.badge.passed { background: var(--pass); } .badge.failed { background: var(--fail); } .badge.investigate { background: var(--inv); }
</style>
</head>
<body>
<main>
<h1>Demo pack report</h1>
<p class="muted">Written by MP.DEMO.1008 at $generated UTC. The data is made up: it shows how a pack adds its own report to the Maester report.</p>
<div class="cards">
<div class="card"><span class="muted">Checks</span><b>$($Check.Count)</b></div>
<div class="card pass"><span class="muted">Passed</span><b>$passed</b></div>
<div class="card fail"><span class="muted">Failed</span><b>$failed</b></div>
<div class="card inv"><span class="muted">Investigate</span><b>$investigate</b></div>
</div>
<input id="filter" type="search" placeholder="Filter the checks" aria-label="Filter the checks">
<table>
<thead><tr><th>ID</th><th>Check</th><th>Area</th><th>Result</th></tr></thead>
<tbody id="rows">$($rows -join '')</tbody>
</table>
</main>
<script>
// Scripts run in the sandboxed frame, so a report can be interactive.
document.getElementById('filter').addEventListener('input', function (e) {
  var q = e.target.value.toLowerCase();
  document.querySelectorAll('#rows tr').forEach(function (tr) { tr.hidden = tr.textContent.toLowerCase().indexOf(q) < 0; });
});
</script>
</body>
</html>
"@
}
