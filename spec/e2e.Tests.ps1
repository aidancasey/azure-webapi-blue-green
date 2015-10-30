
$scriptPath = "C:\Code\ADCommon-AzureDeploy\Run.ps1"
. $scriptPath


Describe 'CreateNewStack' {
    It 'Should create a new website called AidanADCommon with one or more instances' {

      Create-New-Stack

      Switch-AzureMode AzureServiceManagement
      $website = Get-AzureWebsite -Name AidanADCommon
      $website.Instances.Count | Should BeGreaterThan 0
    }
}

Describe 'DeleteEverything' {
        It 'should delete the website called AidanADCommon' {

      Switch-AzureMode AzureServiceManagement
      DeleteEverything

      Switch-AzureMode AzureServiceManagement

      $foo = Get-AzureWebsite -Name ADCommon
      $foo.Instances.Count | Should Be 0

    }
}
