function Test-DemoInvestigate {
    <#
    .SYNOPSIS
    A test whose result needs a person to look at it.
    #>
    [MaesterTest(
        Id       = 'MP.DEMO.1003',
        Title    = 'Demo: a result to investigate',
        Severity = 'Medium'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Add-MtTestResultDetail -Investigate -Result 'Maester cannot decide this one. A person should look at it.'
    $false
}
