#* Register a file share on my local machine
#region

$registerPSRepositorySplat = @{
    Name                 = 'LocalPSRepo'
    SourceLocation       = "$PSScriptRoot\Release\"
    ScriptSourceLocation = "$PSScriptRoot\Release\"
    InstallationPolicy   = 'Trusted'
}

if (!(Test-Path $registerPSRepositorySplat.SourceLocation)) {
    New-Item -Path $registerPSRepositorySplat.SourceLocation -ItemType Directory
}
Unregister-PSRepository -Name $registerPSRepositorySplat.Name -ErrorAction SilentlyContinue
Register-PSRepository @registerPSRepositorySplat -ErrorAction SilentlyContinue
#endregion

#* Build the module
#region

$PSModuleParams = @{
    Author        = "Jack den Ouden"
    CompanyName   = "SysadminHeaven"
    ModuleName    = "$(Split-Path -Path $PSScriptRoot -Leaf)"
    Copyright     = "© 2020-$(Get-Date -Format "yyyy") SysadminHeaven. All rights reserved."
    Source        = ".\Src" #Location functions and tests
    BuildFolder   = ".\Build"
    ReleaseFolder = ".\Release"
    Repository    = "LocalPSRepo"
    BuildType     = "build"
}

Build-PSModule @PSModuleParams -Verbose

#endregion

#* Cleanup and install the Latest version of module
#region

Remove-Module -Name $PSModuleParams.ModuleName -Force -ErrorAction SilentlyContinue
Uninstall-Module -Name $PSModuleParams.ModuleName -Force -ErrorAction SilentlyContinue

Install-Module -Name $PSModuleParams.ModuleName -Repository $PSModuleParams.Repository -Force -ErrorAction SilentlyContinue
Import-Module -Name $PSModuleParams.ModuleName -Force -ErrorAction SilentlyContinue

#endregion
