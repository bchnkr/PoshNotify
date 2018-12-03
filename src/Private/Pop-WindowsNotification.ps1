Function Pop-WindowsNotification {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]
        $Body,

        [Parameter(Mandatory=$true)]
        [string]
        $Title,

        [Parameter()]
        [string]
        $Icon = "$PSScriptRoot\lib\alarm.png",

        [Parameter()]
        [switch]
        $Silent
    )

    if ($Silent) {
        $SoundElement = '<audio silent="true" />'
    } else {
        $SoundElement = '<audio src="ms-winsoundevent:Notification.Default" />'
    }

    $XmlString = @"
    <toast>
    <visual>
        <binding template="ToastGeneric">
        <text>$Title</text>
        <text>$Body</text>
        <image src="$Icon" placement="appLogoOverride" hint-crop="circle" />
        </binding>
    </visual>
    $SoundElement
    </toast>
"@

    $AppId = Get-WindowsAppId

    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
    $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $ToastXml.LoadXml($XmlString)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($ToastXml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
}
