function SetSubscriptionInfo([string]$publishFile, [string]$subscriptionName)
{
   Import-AzurePublishSettingsFile $publishFile
   Select-AzureSubscription $subscriptionName
   Add-AzureAccount
}

function Create-Stack([string]$resourceGroupName, [string]$templateFile , [string]$templateParameterFile,[string]$location)
{
    Switch-AzureMode -Name AzureResourceManager
    New-AzureResourceGroup –Name $name –Location $location
    New-AzureResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile  -TemplateParameterFile $templateParameterFile
}





function GrantFirewallAccessToDatabase([string]$server, [string]$ipAddress)
{
       Switch-AzureMode AzureServiceManagement
       New-AzureSqlDatabaseServerFirewallRule -ServerName $server -RuleName "FirewallRule24" -StartIPAddress $ipAddress -EndIPAddress $ipAddress
}

function Publish-Website([string]$name, [string]$package)
{
       Switch-AzureMode AzureServiceManagement
       Write-Host "publishing " + $name + "..."
       Publish-AzureWebsiteProject -Name $name -Package $package
}

function Stage-Website([string]$name, [string]$package)
{
       Switch-AzureMode AzureServiceManagement
       Write-Host "publishing " + $name + "..."
       Publish-AzureWebsiteProject -Name $name -Package $package  -Slot "Stage"
}

function Swap-Website([string]$name)
{
    Switch-AzureWebsiteSlot –Name $name -Force
}

function Delete-ResourceGroup([string]$name )
{
    Switch-AzureMode -Name AzureResourceManager

    $group  = Get-AzureResourceGroup -Name $name

    if ($group.Count -gt 0 )
    {
        Remove-AzureResourceGroup $name -Force
    }
}

function Add-StagingSlot([string]$sitename,[string]$location)
{
    New-AzureWebsite -Name $sitename  -Location $location -Slot "Stage"
}