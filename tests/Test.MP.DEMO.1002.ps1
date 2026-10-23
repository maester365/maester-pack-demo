function Test-DemoAlwaysFails {
    <#
    .SYNOPSIS
    A test that always fails, with a table of made-up findings.
    #>
    [MaesterTest(
        Id       = 'MP.DEMO.1002',
        Title    = 'Demo: a test that fails',
        Severity = 'High'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $findings = @(
        [pscustomobject]@{ Name = 'Contoso app one'; Setting = 'Disabled' }
        [pscustomobject]@{ Name = 'Contoso app two'; Setting = 'Disabled' }
    )
    $rows = foreach ($finding in $findings) { "| $($finding.Name) | $($finding.Setting) |" }
    $result = "These made-up items fail the check:`n`n| Name | Setting |`n| --- | --- |`n" + ($rows -join "`n")
    Add-MtTestResultDetail -Result $result
    $false
}
