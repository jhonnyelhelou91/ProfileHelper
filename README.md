# Profile Helpers

PowerShell Helper scripts to manage PowerShell current user profiles.

## Getting Started

* Copy the files
* Open Command Line or PowerShell (*Window + X, A*)
* If you opened Command Prompt, then type *powershell* in order to use PowerShell commands
* Navigate to the scripts directory <br />`cd your_directory`
* Type <br />`Import-Module .\EnvironmentVariables.psm1`
* Now you can use the methods from your PowerShell session

### Adding Script to Profile [Optional]

* Enable execution policy using PowerShell Admin <br /> `Set-ExecutionPolicy Unrestricted`
* Navigate to the profile path <br />`cd (Split-Path -parent $PROFILE)`
* Open the location in Explorer <br />`ii .`
* Create the user profile if it does not exist <br />`If (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }`
* Import the module in the PowerShell profile <br />`Import-Module -Path script_directory -ErrorAction SilentlyContinue`

### Examples

#### Add-Profile Example
Create current user profile for PowerShell if it does not exist
<details>
   <summary>Create Profile</summary>
   <p>Add-Profile</p>
</details>

#### Import-Profile Example
Import 1 or more modules/scripts to current user PowerShell profile
<details>
   <summary>Import Script to Profile</summary>
   <p>Import-Profile -Path "C:\git\PowerShell\ProfileHelpers.psm1"</p>
</details>
<details>
   <summary>Import Multiple Scripts to Profile</summary>
   <p>Import-Profile -Path "C:\git\PowerShell\"</p>
</details>

#### Update-Profile Example
Reload current user profile for PowerShell after modifying in imported modules/scripts or in profile
<details>
   <summary>Update Profile</summary>
   <p>Update-Profile</p>
</details>

#### Add-NuGetProfile Example
Create current user NuGet profile for PowerShell if it does not exist
<details>
   <summary>Create NuGet Profile</summary>
   <p>Add-NuGetProfile</p>
</details>

#### Import-NuGetProfile Example
Import 1 or more modules/scripts to current user PowerShell NuGet profile
<details>
   <summary>Import Script to NuGet Profile</summary>
   <p>Import-NuGetProfile -Path "C:\git\PowerShell\ProfileHelpers.psm1"</p>
</details>
<details>
   <summary>Import Multiple Scripts to Profile</summary>
   <p>Import-NuGetProfile -Path "C:\git\PowerShell\"</p>
</details>

#### Update-Profile Example
Reload current user NuGet profile for PowerShell after modifying in imported modules/scripts or in NuGet profile
<details>
   <summary>Update Profile</summary>
   <p>Update-NuGetProfile</p>
</details>
