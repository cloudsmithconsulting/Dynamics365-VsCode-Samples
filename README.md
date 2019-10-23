# ![Cloudsmith Consulting LLC](https://cloudsmithstatics.azureedge.net/web/cloudsmith-notagline-450x103.png "Cloudsmith Consulting")<br> Welcome to the Dynamics 365 Development tools for VSCode
This sample is designed to help developers with a simple (manual) development loop using Visual Studio Code.  Many developers do not have access to a full Visual Studio license in order to use Microsoft's Dynamics CRM Development Toolkit.  This sample solution is designed to get you started.

---

## Pre-requisites for using this toolkit
If you are reading this file on a VM Deployed from CloudSmith's project template system, these actions are completed.

1. Download and install the CRM SDK into `C:\Deploy\CRMSDK`
  > You can initiate the download and install automatically by running `.\Install-Sdk.ps1` in the `CloudSmith.Dynamics365.SampleScripts` project.
  > This installation will automatically rename and restructure SDK folders into logical groups.

2. Download and install `Microsoft.Xrm.Data.PowerShell` 
  > You can initiate the download and install by running Install-Module Microsoft.Xrm.Data.PowerShell from a PowerShell prompt.

3. Generated `XrmEntities.cs` for use in testing/applications via `CrmSvcUtil`
  > You can initiate the download and install by running Install-Module Microsoft.Xrm.Data.PowerShell from a PowerShell prompt.

---

# What's inside this toolkit?
There are 2 "projects" with several components inside this toolkit.  Inside each project are a number of files, described below:

## CloudSmith.Dynamics365.CrmSvcUtil
**What is it?**  
Service Utility extensions for CrmSvcUtil.exe that make it much more useful.  You can [read about it here](CloudSmith.Dynamics365.CrmSvcUtil/ReadMe.md).

## CloudSmith.Dynamics365.SampleScripts
**What is it?**  
PowerShell scripts that handle the basic development loop of managing a CRM solution in Visual Studio Code.

| File                         | Purpose                                                              |
| ---------------------------- | -------------------------------------------------------------------- |
| `Deploy-XrmSolution.ps1` | Deploys a CRM Solution from the local filesystem to the server |
| `Generate-XrmEntities.ps1` | Generates a new `XrmEntities.cs` file for use in .Net applications |
| `Get-XrmSolution.ps1` | Obtains a CRM Solution from the server and extracts it into the filesystem |
| `Install-Sdk.ps1` | Installs the Dynamics CRM SDK into a specified folder on the filesystem. |
| `Install-XrmToolbox.ps1` | Installs the open-source XrmToolbox solution on the filesystem. |
| `runonce-script.ps1` | Script initializes VSCode and all needed pre-requisites to use this toolkit. |
| `Setup-EasyRepro.ps1` | Configures Internet Explorer security settings so that [EasyRepro](https://github.com/Microsoft/EasyRepro) can be used with IE for On-Premises deployments. |
| `vscode-extensions.txt` | A list of VSCode extensions that enable or ease development tasks related to Dynamics development. |

## CloudSmith.Dynamics365.SampleTests
**What is it?**  
Microsoft Unit Tests (MSTest) related to some commonly required tasks for Dynamics 365 Developers.

| File                         | Purpose                                                              |
| ---------------------------- | -------------------------------------------------------------------- |
| `DataGenerationTests.cs` | Contains several examples of generating sets of data (static and dynamic) for use in Dynamics 365.  The dynamic test data generation is done with [Bogus](https://github.com/bchavez/Bogus).
| `InteractiveBrowserTests.cs` | Contains test samples of using EasyRepro with Dynamics 365 (version 8.2 is packaged by default, but can be updated)

---

# Examples and how-to guides of tasks this toolkit facilitates

## Task: Download and install the CRM SDK
1. Open `Install-Sdk.ps1`.
2. Modify the destination folder (if desired)
3. Run the script.

## Task: Generate new XrmEntities
1. Open the `Generate-XrmEntities.ps1` file from `CloudSmith.Dynamics365.SampleScripts`.
2. Change the target path (if desired) on line 15.
3. Run the script.

## Task: Get a solution from Dynamics CRM and put it in source control
1. Open the `Get-XrmSolution.ps1` file from `CloudSmith.Dynamics365.SampleScripts`.
2. Change the solution name that you want to get on line 2.
3. Change the server and organization name on line 15.
4. Change the destination path on line 36.
5. Run the script.
6. Execute a `git push` to commit the changes to source control.

## Task: Push changes from source control into a solution in Dynamics CRM
1. Open the `Deploy-XrmSolution.ps1` file from `CloudSmith.Dynamics365.SampleScripts`.
2. Change the solution name that you want to get on line 2.
3. Change the server and organization name on line 15.
4. Change the destination path on line 36.
5. Run the script.

## Task: Run browser-based tests using EasyRepro
1. Run the `Setup-EasyRepro.ps1` file from `CloudSmith.Dynamics365.SampleScripts` (only needs to be done once).
2. Update line 10 of `InteractiveBrowserTests.cs` from `CloudSmith.Dynamics365.SampleTests` with the URL of your Dynamics 365 environment.
3. Open Test Explorer in VSCode (an add-on specified in `vscode-extensions.txt`) using the "test" icon.
4. Expand the test tree under `InteractiveBrowserTests`.
5. Press the run button next to either `OpenAccountsGrid` or `SwitchDashboard`.

## Task: Generate a set of data for use in Dynamics 365
1. Update line 13 of `DataGenerationTests.cs` from `CloudSmith.Dynamics365.SampleTests` with the credentials of your Dynamics 365 environment.
2. Open Test Explorer in VSCode (an add-on specified in `vscode-extensions.txt`) using the "test" icon.
3. Expand the test tree under `DataGenerationTests`.
4. Press the run button next to either `GenerateRandomAccounts` or `GenerateRandomAccountsWithContacts`.