# Maester demo pack

A [Maester Pack](https://maester.dev/docs/packs) for trying out packs. Every test is made up: none of them
changes anything, and only MP.DEMO.1007 reads your tenant (the organization's name, from Microsoft Graph).

## Install and run

```powershell
Install-MtPack maester365/maester-pack-demo
Invoke-Maester -Pack DEMO
```

`-Pack DEMO` runs only this pack, including its long-running test. To connect the pack's own made-up
service first, so MP.DEMO.1006 runs instead of being skipped:

```powershell
Connect-Maester -Service DEMO.Sample
# or, to see it fail:
Connect-Maester -Service DEMO.Sample -ServiceSetting @{ MfaRequired = $false }
```

To try it from a clone without installing it:

```powershell
Test-MtPack ./maester-pack-demo
Invoke-MtTest -Path ./maester-pack-demo
```

## Tests

| ID | Title | What it shows |
| --- | --- | --- |
| MP.DEMO.1001 | Demo: a test that passes | A Passed result |
| MP.DEMO.1002 | Demo: a test that fails | A Failed result with a table and a remediation |
| MP.DEMO.1003 | Demo: a result to investigate | An Investigate result |
| MP.DEMO.1004 | Demo: a test that skips itself | A Skipped result with a custom reason |
| MP.DEMO.1005 | Demo: a test that errors | An Error result from a thrown error |
| MP.DEMO.1006 | Demo: the sample service requires MFA | The pack's own connector (`DEMO.Sample`), and a skip when it is not connected |
| MP.DEMO.1007 | Demo: read the tenant from Microsoft Graph | A Graph read, declared in the manifest |
| MP.DEMO.1008 | Demo: a long-running test with live progress and a report | `Write-MtTestOutput`, `Write-MtTestProgress` and `Add-MtReportAttachment` |

## What's in the pack

- `maester-pack.json`: the manifest. It declares the connector, the services the tests use and the Graph scope.
- `tests/`: the suite, one `Test.<ID>.ps1` and `Test.<ID>.md` per test.
- `helpers/`: `Get-DemoSampleSetting`, which the tests call.
- `connector/`: `Connect-DemoSample`, `Test-DemoSample` and `Disconnect-DemoSample` for the made-up service.

See [Writing a pack](https://maester.dev/docs/packs/writing-a-pack) to make your own.
