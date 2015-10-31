
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory /scripts/upgrade-db.ps1)
. (Join-Path $ScriptDirectory /scripts/azure-commands.ps1)
. (Join-Path $ScriptDirectory /scripts/public-ip-settings.ps1)


Function Create-New-Stack()
{
    $resourceGroupName = "CustomerServiceStack"
    $templateFile = $PSScriptRoot + "\webapi-deploy.json"
    $templateParams = $PSScriptRoot + "\webapi-deploy-parameters.json"
    $region ="North Europe"

    Create-Stack $resourceGroupName $templateFile $templateParams $region

    Add-Staging-Slot
}

Function Deploy-DB-Schema()
{
    #add firewall rule to connect from this pc to the db

    $dbServer = "tcp:aidandbq4.database.windows.net,1433"
    $dbName = "CustomerDB"
    $user = "dbuser"
    $password = "Fooboohoo12345"
    $ipAddress = Get-MyPublicIP
    GrantFirewallAccessToDatabase "CustomerDB" $ipAddress
}

Function Deploy-Web-App()
{
   $pathToDeployPackage = $PSScriptRoot + "\build artefacts\web\v1.zip"
   $websiteName = "CustomerService"
   Publish-Website $websiteName $pathToDeployPackage
}

Function DeployV2ToStage()
{
   $pathToDeployPackage = $PSScriptRoot + "\build artefacts\web\v2.zip"
   $websiteName = "CustomerService"

   Stage-Website $websiteName $pathToDeployPackage
}


function Add-Staging-Slot()
{
    Add-StagingSlot "CustomerService" "North Europe"
}

function Swap()
{
    Swap-Website "CustomerService"
}

function DeleteEverything()
{
  Delete-ResourceGroup "CustomerServiceStack"
}


# set azure account
$filePath = $PSScriptRoot + "\credentials\trial.publishsettings"

SetSubscriptionInfo $filePath "Free Trial"

Create-New-Stack
Deploy-Web-App
Deploy-DB-Schema
DeployV2ToStage
Swap


#DeleteEverything