function Test-DemoAlwaysPasses {
    <#
    .SYNOPSIS
    A test that always passes and needs no connection.
    #>
    [MaesterTest(
        Id       = 'MP.DEMO.1001',
        Title    = 'Demo: a test that passes',
        Severity = 'Info'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Add-MtTestResultDetail -Result 'Well done. This test always passes.'
    $true
}
