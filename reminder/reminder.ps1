# Lab reminder.
# The Working Centre

# Based on
# https://bytecookie.wordpress.com/2011/12/28/gui-creation-with-powershell-part-2-the-notify-icon-or-how-to-make-your-own-hdd-health-monitor/

# Balloon timing is set in accessibility settings.

[void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

# Assemblies
#    try {
#        Add-Type -AssemblyName "System.Drawing" -ErrorAction Stop
#        Add-Type -AssemblyName "System.Windows.Forms" -ErrorAction Stop
#    }
#    catch [System.UnauthorizedAccessException] {
#        Write-Warning -Message "Access denied when attempting to load required assemblies" ; break
#    }
#    catch [System.Exception] {
#        Write-Warning -Message "Unable to load required assemblies. Error message: $($_.Exception.Message)" ; break
#    }


if($PSVersionTable.PSVersion.Major -ge 3)
{
        $scope = 2
}
else
{
        $scope = 1
}


$elapsed = 0

# Determine location of script.
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDir  = Split-Path -Parent $ScriptPath

# Create hidden form.
$form1 = New-Object System.Windows.Forms.form

# Notify icon.
$NotifyIcon= New-Object System.Windows.Forms.NotifyIcon

# Timer to perform announcement.
$Timer = New-Object System.Windows.Forms.Timer

# Temporary icons.
$iconOK = New-Object System.Drawing.Icon($ScriptDir + "\reminder.ico")



# Form configuration.
$form1.ShowInTaskbar = $false
$form1.WindowState = "minimized"

# Icon configuration.
$NotifyIcon.Icon =  $iconOK
$NotifyIcon.Visible = $True


# Deliberate click.
$NotifyIcon.add_Click({
    $NotifyIcon.ShowBalloonTip(5*1000,"Welcome","Be mindful of others needing to use public computers.",[system.windows.forms.ToolTipIcon]"None")
})


# Interval between ticks in milliseconds.
$Timer.Interval = 1000

$Timer.add_Tick({CountTime})
$Timer.Enabled = $true
$Timer.Start()


function CountTime() {

    Set-Variable -Name elapsed -Value ($elapsed + 1) -Scope $scope
    #$elapsed = $elapsed + 1

    if ($elapsed -gt 10) {

      $NotifyIcon.Icon =  $iconOK

      $NotifyIcon.ShowBalloonTip(1*1000,"Welcome","Please be mindful of others waiting to use public computers.",[system.windows.forms.ToolTipIcon]"Info")

      #$elapsed = 0
      Set-Variable -Name elapsed -Value 0 -Scope $scope

    }

    else {

        $NotifyIcon.Icon =  $iconOK

    }

}


#TODO on graceful exit.
#   $form1.close()
# [System.Windows.Forms.Application]::Exit($null)

#[void][System.Windows.Forms.Application]::add_ApplicationExit({
#try 
#{$form1.close()
#} catch {}
#})


Write-Output "Reminder starting..."

# Show once to verify it works.
$NotifyIcon.ShowBalloonTip(1000,"Welcome!!","Please be mindful of others waiting to use public computers.",[system.windows.forms.ToolTipIcon]"Info")


[void][System.Windows.Forms.Application]::Run($form1)

