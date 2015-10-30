
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

$module= $here.Replace("\spec", "\scripts\$sut")
$code = Get-Content $module | Out-String
Invoke-Expression $code

#Describe 'Create-Stack' {
#    Switch-AzureMode -Name AzureResourceManager
#
#        $hash = @{
#        ProvisioningState       = "Succeeded"
#    }
#
#    $mockObj = New-Object PSObject -Property $hash
#    Write-Host $mockObj
#
#    Mock Azure-New-AzureResourceGroup -MockWith { return $mockObj } -ParameterFilter{$name -eq"Group 1" -and  $location -eq "North Europe"}
#    Mock Azure-New-AzureResourceGroupDeployment -MockWith { return $true } -ParameterFilter{$resourceGroupName -eq"Group 1" }
#
#    It 'Creates a new resource group and deploys the stack to the group' {
#        Create-Stack "Group 1" "file1" "file2" "North Europe"
#        Assert-MockCalled Azure-New-AzureResourceGroup
#        Assert-MockCalled Azure-New-AzureResourceGroupDeployment
#    }
#}
