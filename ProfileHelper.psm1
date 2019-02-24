$ErrorActionPreference = "Stop"
function Add-NuGetProfile {
	$profileDirectory = Split-Path $PROFILE -parent;
    $nugetProfile = "$profileDirectory\NuGet_profile.ps1";
	
    If (!( Test-Path $nugetProfile )) { 
	    New-Item $nugetProfile  -Type  File  -Force;
	    Write-Host "Powershell NuGet Profile created";
    }
	
	return $nugetProfile;
}
function Add-Profile {
    If (!( Test-Path $PROFILE )) { 
	    New-Item $PROFILE  -Type  File  -Force;
	    Write-Host "Powershell Profile created";
    }
	
	return $PROFILE;
}
function Import-ProfilePathInternal {
Param (
	[string]
	$profilePath,
	
	[string]
	$path
);
	$profileContent  =  Get-Content  $profilePath
	
	$pathItem = (Get-Item $path);

	If ($pathItem -is [System.IO.DirectoryInfo])
	{
		#Update profile
		cd "$path";
		$scripts = Get-ChildItem -Path "$path" -File "*.psm1" -Recurse
		"`n" | Add-Content $PROFILE -Encoding UTF8;
		
		$scripts | ForEach {
			If (!( $profileContent -Like  "*$($_.FullName)*"  ))  {
				$content = "Import-Module '$($_.FullName)' -WarningAction Ignore"
				$content | Add-Content $profilePath -Encoding  UTF8
			}
		}
	}
	Else {
		If (!( $profileContent -Like  "*$($path)*"  ))  {
			$content = "Import-Module '$path' -WarningAction Ignore"
			$content | Add-Content $profilePath -Encoding  UTF8
		}
	}
    Write-Host "Powershell Profile Updated";

     Write-Host "Reloading Profile";
    . $profilePath
}
function Import-ProfilePath {
Param (		
	[Parameter(Mandatory=$false)]
	[string]
	$path = (Read-Host -prompt "Scripts Path Or Directory")
)
    $profilePath = Add-Profile;
	Import-ProfilePathInternal $profilePath $path
}
function Import-NuGetProfilePath {
Param (		
	[Parameter(Mandatory=$false)]
	[string]
	$path = (Read-Host -prompt "Scripts Path Or Directory")
)
    $profilePath = Add-NuGetProfile;
	Import-ProfilePathInternal $profilePath $path	
}
function Update-ProfileInternal {
Param(
	[string]
	$profilePath
);
    If ((Test-Path $profilePath)) {
	    $importModules =  Get-Content  $profilePath;
		$patterns = (
			"^Import-Module.*-Name.*(.*).psm1",
			'^Import-Module.*-Name.*"(.*).psm1"',
			"^Import-Module.*-Name.*'(.*).psm1'",
			"^Import-Module (.*).psm1",
			'^Import-Module "(.*).psm1"',
			"^Import-Module '(.*).psm1'"
		);
		$pattern = $patterns -join '|';
		$matches = $importModules | Select-String -Pattern "$pattern" -AllMatches;
		
        Foreach($removeModule in $matches) {
            $modulePath = ($removeModule -replace 'Import-Module', '');
			$start = $modulePath.IndexOf("-Name");
			If ($start -eq -1) {
				$start = 0;
			} Else {
				$start += 5;
			}
			$offset = ".psm1".length;
			
			$index = $modulePath.IndexOf(".psm1'");
			If ($index -eq -1) {
				$index = $modulePath.IndexOf('.psm1"');
			}
			If ($index -eq -1) {
				$index = $modulePath.IndexOf(".psm1");
			}
			If ($index -eq -1) {
				Write-Warning "Unable to remove module $modulePath"
				continue;
			}
			
			$modulePath = $modulePath.Substring($start, $index - $start + $offset).Trim().Trim("'", '"');
			$moduleName = $modulePath.Substring($modulePath.LastIndexOf('\') + 1).Split('.')[0];
			
            $module = Get-Module $moduleName;

            If ($module -eq $null) {
				Write-Warning "Module $moduleName does not exist";
			}
			If ($module.Path -ne $modulePath) {
                Write-Warning "Module $moduleName is not found for path $modulePath";
            }
            Else {
                Remove-Module $moduleName;
                Write-Host "Module $moduleName successfully removed from path $modulePath";
            }
        }
        . $profilePath
        Write-Host "Profile Loaded"
    }
}
function Update-Profile {
	Update-ProfileInternal $PROFILE
}
function Update-NuGetProfile {
	$profileDirectory = Split-Path $PROFILE -parent;
    $nugetProfile = "$profileDirectory\NuGet_profile.ps1";
	
	If (Test-Path $nugetProfile)
	{
		Write-Warning "$nugetProfile does not exist";
	}
	Else
	{
		Update-ProfileInternal $nugetProfile
	}
}

Export-ModuleMember -Function Add-Profile
Export-ModuleMember -Function Import-Profile
Export-ModuleMember -Function Update-Profile
Export-ModuleMember -Function Import-NuGetProfile
Export-ModuleMember -Function Add-NuGetProfile
Export-ModuleMember -Function Update-NuGetProfile
