function Test-DemoSkipped {
    <#
    .SYNOPSIS
    A test that skips itself with a reason of its own.
    #>
    [MaesterTest(
        Id       = 'MP.DEMO.1004',
        Title    = 'Demo: a test that skips itself',
        Severity = 'Low'
    )]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Add-MtTestResultDetail -SkippedBecause Custom -SkippedCustomReason 'This demo test always skips itself.'
}
