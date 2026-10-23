![Maester demo pack](assets/banner.png)

# Maester demo pack

A [Maester Pack](https://maester.dev/docs/packs) to try packs out, and the one to copy when you write your own.
Every test uses made-up data and changes nothing. Only MP.DEMO.1007 reads your tenant: the organization's name,
from Microsoft Graph.

## Try it

```powershell
Install-MtPack maester365/maester-pack-demo
Invoke-Maester -Pack DEMO
```

`-Pack DEMO` runs only this pack, including its long-running test. Run it in a console that is large enough for
the full-screen dashboard to see the live progress of MP.DEMO.1008. To run the pack's connector test
(MP.DEMO.1006) instead of skipping it, connect its made-up service first:

```powershell
Connect-Maester -Service DEMO.Sample
# or, to see it fail:
Connect-Maester -Service DEMO.Sample -ServiceSetting @{ MfaRequired = $false }
```

| ID | What it shows |
| --- | --- |
| MP.DEMO.1001 | A Passed result |
| MP.DEMO.1002 | A Failed result with a table and a remediation, and a setting (`MinimumScore`) each tenant can change |
| MP.DEMO.1003 | An Investigate result |
| MP.DEMO.1004 | A Skipped result with a reason of its own |
| MP.DEMO.1005 | An Error result from a test that throws |
| MP.DEMO.1006 | The pack's own connector for a made-up service (`DEMO.Sample`), and the skip when it is not connected |
| MP.DEMO.1007 | A Microsoft Graph read, declared in the manifest |
| MP.DEMO.1008 | A long-running test: live output and progress in the dashboard, and its own report in the Maester report |
| MP.DEMO.1009 | A family: one result per object (three made-up apps) |

Change a setting in your `maester-config.json`:

```json
{
  "TestSettings": [
    { "Id": "MP.DEMO.1002", "Parameters": { "MinimumScore": 70 } },
    { "Id": "MP.DEMO.1008", "Parameters": { "ItemMilliseconds": 200 } }
  ]
}
```

## Make your own pack from this one

1. Press **Use this template** on GitHub (or clone this repository) to make a repository of your own, under the
   GitHub user or organisation that will publish the pack.
2. In your copy, run the setup function with your pack's ID, code and name:

   ```powershell
   . ./tools/Initialize-MtPackFromDemo.ps1
   Initialize-MtPackFromDemo -Id contoso.google-workspace -Code CNT -Name 'Contoso Google Workspace checks'
   ```

   It renames the pack, its tests (`MP.CNT.1001` and so on), its service and its functions, gives it a new GUID
   and points the links at your repository.
3. Replace the made-up tests with your own. Keep the ones whose pattern you need (a family, a setting, a
   connector, a long-running test) and delete the rest.
4. Replace `assets/banner.png`, or remove `Banner` from the manifest. See
   [Banner image](https://maester.dev/docs/packs/writing-a-pack#banner-image).
5. Check the pack and run its tests from the folder:

   ```powershell
   Test-MtPack .
   Invoke-MtTest -Path .
   ```

6. Delete the `tools` folder, push, and create a GitHub release such as `v0.1.0`. Others install it
   with `Install-MtPack <owner>/<repository>`.

To start from an empty pack instead, run `New-MtPack`. The full guide is
[Writing a pack](https://maester.dev/docs/packs/writing-a-pack).

## What this pack does that yours should too

- **Declare what it reaches.** `Uses` in `maester-pack.json` lists the services, Graph scopes, network hosts and
  modules the pack uses. Install-MtPack shows it to the person installing, and the content checks compare it
  with the code. Keep `TenantWrites` empty unless the pack changes the tenant.
- **Let the engine handle connections and errors.** A test declares `Service`; the engine skips it when that
  service is not connected, and turns an uncaught error into an Error row. No connection checks or
  `try`/`catch` around the whole test.
- **Lead with the finding.** Each result starts with one sentence that says what was found, then the detail as
  a table. Each `.md` says what the test checks and how to fix it, under `#### Remediation action`.
- **Make thresholds settings.** A value a tenant may want to change is a test parameter with a default and a
  `ValidateRange` (MP.DEMO.1002), not a constant.
- **One row per object.** A check of many objects of one kind is a family with an `InstanceSource`
  (MP.DEMO.1009), so each object can be seen, excluded or accepted on its own.
- **Group the results.** `Product`, `Feature`, `Area` and `ResourceType` group the tests in the console and the
  report.
- **Show long work while it runs.** A test that runs for more than a few seconds writes its log with
  `Write-MtTestOutput` and its progress with `Write-MtTestProgress`: stages, items, errors, and its own results
  by group. A tool in another process writes `##maester[progress]` lines instead (MP.DEMO.1008).
- **Add a tool's report to the Maester report.** `Add-MtReportAttachment` puts a single-file HTML report under
  **Reports** in the report's left menu. It runs in a sandboxed frame, so keep it to one file with everything
  inline, and HTML-encode values from the tenant (`helpers/Get-DemoReportHtml.ps1`).
- **Be easy to trust.** A licence, `Homepage`, `Support` and `SecurityContact` in the manifest, a
  [security policy](SECURITY.md), a [changelog](CHANGELOG.md), and a check on every pull request
  ([.github/workflows/check-pack.yml](.github/workflows/check-pack.yml)).

## Files

| Path | What it is |
| --- | --- |
| `maester-pack.json` | The manifest: ID, code, version, the suite, helpers, the connector and what the pack uses |
| `tests/` | The suite: `suite.json`, and one `Test.<ID>.ps1` and `Test.<ID>.md` per test |
| `helpers/` | Functions the tests call: the connector's settings and the HTML report |
| `connector/` | `Connect-`, `Test-` and `Disconnect-DemoSample` for the made-up service |
| `assets/banner.png` | The image the pack index shows when it features the pack |
| `tools/` | `Initialize-MtPackFromDemo`, which turns a copy into your own pack; delete the folder afterwards. The pack never loads it |
