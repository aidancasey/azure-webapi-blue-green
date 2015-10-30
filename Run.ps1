
$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDirectory /scripts/upgrade-db.ps1)
. (Join-Path $ScriptDirectory /scripts/azure-commands.ps1)
. (Join-Path $ScriptDirectory /scripts/public-ip-settings.ps1)


Function Create-New-Stack()
{
    $resourceGroupName = "ADCommonStack"
    $templateFile = $PSScriptRoot + "\azuredeploy.json"
    $templateParams = $PSScriptRoot + "\azuredeploy-parameters.json"
    $region ="North Europe"

    Create-Stack $resourceGroupName $templateFile $templateParams $region

    Add-Staging-Slot
}

Function DeploySchema()
{
    #add firewall rule to connect from this pc to the db

    $dbServer = "tcp:aidandbq4.database.windows.net,1433"
    $dbName = "ADCommon"
    $user = "aidan"
    $password = "Fooboohoo12345"
    $ipAddress = Get-MyPublicIP
    GrantFirewallAccessToDatabase "aidandbq4" $ipAddress

    #run the db upgrade tool

 #   $pathtoUpgradeExe = $PSScriptRoot + "\build artefacts\DBUpgrade\MYOB.AD.DbUpgrade.exe"
 #   UpgradeDatabaseSchema $pathtoUpgradeExe $dbServer $dbName $user $password
}

Function Deploy-Web-App()
{
   $pathToDeployPackage = $PSScriptRoot + "\build artefacts\web\MYOB.Server.API.zip"
   $websiteName = "AidanADCommon"
   Publish-Website $websiteName $pathToDeployPackage
}

Function DeployV2ToStage()
{
   $pathToDeployPackage = $PSScriptRoot + "\build artefacts\web\v2.zip"
   $websiteName = "AidanADCommon"

   Stage-Website $websiteName $pathToDeployPackage
}


function Add-Staging-Slot()
{
    Add-StagingSlot "AidanADCommon" "North Europe"
}

function Swap()
{
    Swap-Website "AidanADCommon"
}

function DeleteEverything()
{
  Delete-ResourceGroup "ADCommonStack"
}

# set azure account
$filePath = $PSScriptRoot + "\credentials\trial.publishsettings"

#SetSubscriptionInfo $filePath "Free Trial"

#Create-New-Stack

#Deploy-Web-App

#DeployV2ToStage
#Swap

#DeploySchema

#DeleteEverything