```powershell
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Windows.Forms.Application]::EnableVisualStyles()  

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

Add-PSSnapin citrix*

$Form = New-Object system.Windows.Forms.Form 
$Form.Size = New-Object System.Drawing.Size(500, 400) 
$Form.Text = "Citrix VDI Assignment Tool"
$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
#$Form.BackColor = "lightblue"
#$FormIcon = New-Object system.drawing.icon ("C:\temp\Powershell.ico")
$Form.Icon = $FormIcon
$Form.FormBorderStyle = 'Fixed3D'
$form.MaximizeBox = $false

#username label
$Label = New-Object System.Windows.Forms.Label 
$Label.Text = "Enter User Name:" 
$Label.AutoSize = $true 
$Label.Location = New-Object System.Drawing.Size(20, 50) 
$Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold) 
$form.Font = $Font
$Form.Controls.Add($Label)

#citrix server label
$CtxLabel = New-Object System.Windows.Forms.Label 
$CtxLabel.Text = "Enter Citrix Server Name:" 
$CtxLabel.AutoSize = $true 
$CtxLabel.Location = New-Object System.Drawing.Size(20, 105) 
$Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold) 
$form.Font = $Font
$Form.Controls.Add($CtxLabel)

#Domain name label
$DomainLabel = New-Object System.Windows.Forms.Label 
$DomainLabel.Text = "Enter Domain Name:" 
$DomainLabel.AutoSize = $true 
$DomainLabel.Location = New-Object System.Drawing.Size(20, 155) 
$Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold) 
$form.Font = $Font
$Form.Controls.Add($DomainLabel)

#username text box
$UserNameTxtBx = New-Object System.Windows.Forms.TextBox
$UserNameTxtBx.Location = New-Object System.Drawing.Point(150, 50)
$UserNameTxtBx.Size = New-Object System.Drawing.Size(280, 500)
$form.Controls.Add($UserNameTxtBx)

#citrix server text box
$CtxSrvtxtbx = New-Object System.Windows.Forms.TextBox
$CtxSrvtxtbx.Location = New-Object System.Drawing.Point(195, 100)
$CtxSrvtxtbx.Size = New-Object System.Drawing.Size(235, 600)
$form.Controls.Add($CtxSrvtxtbx)

#domain name text box
$DomainNametxtbx = New-Object System.Windows.Forms.TextBox
$DomainNametxtbx.Location = New-Object System.Drawing.Point(160, 150)
$DomainNametxtbx.Size = New-Object System.Drawing.Size(270, 400)
$form.Controls.Add($DomainNametxtbx)

#list delivery group published names
$listBox = new-object System.Windows.Forms.ComboBox
$listBox.Location = New-Object System.Drawing.Point(18, 240)
$listBox.Size = New-Object System.Drawing.Size(410, 22)
$form.controls.Add($listBox)

#List Delivery group
$GetVDIGrps = New-Object System.Windows.Forms.Button 
$GetVDIGrps.Location = New-Object System.Drawing.Size(15, 200) 
$GetVDIGrps.Size = New-Object System.Drawing.Size(130, 30) 
$GetVDIGrps.Text = "Get VDI Groups" 
$GetVDIGrps.Add_Click( {
        if (!($CtxSrvtxtbx.text)) {
            [System.Windows.MessageBox]::Show('Please enter citrix server name and try again', 'Empty Value', 'Ok', 'Hand')
        }
        else {
            $listbox.Items.Clear()
            $citrixServer = $CtxSrvtxtbx.Text
            $VDIlist = (Get-BrokerDesktopGroup -adminaddress $citrixServer).PublishedName
            foreach ($dgpubName in $VDIlist) {
                $listbox.Items.Add($dgpubName)
            }
        }
    }) 
$Form.Controls.Add($GetVDIGrps)

#assignVDI button
$assignVDI = New-Object System.Windows.Forms.Button 
$assignVDI.Location = New-Object System.Drawing.Size(15, 300) 
$assignVDI.Size = New-Object System.Drawing.Size(130, 30) 
$assignVDI.Text = "Assign VDI" 
$assignVDI.Add_Click( {

        $DomainNameValue = $DomainNametxtbx.text
        $userNameValue = $UserNameTxtBx.Text
        $ctxsrvnamevalue = $CtxSrvtxtbx.Text

        if ($DomainNameValue -like "*.*") {
            $DomainNameValue = $DomainNameValue.Split('.')[0]
        }

        $dgdisname = $listbox.SelectedItem

        #List all delivery groups.
        $dgname = Get-BrokerDesktopGroup -Name $dgdisname -AdminAddress $ctxsrvnamevalue
        $VDIname = (Get-BrokerDesktop -DesktopGroupName $dgname.Name -adminaddress $ctxsrvnamevalue -MaxRecordCount 2000000 | Where-Object { !($_.AssociatedUserNames) }).DNSName
        if (!$VDIname) {
            [System.Windows.MessageBox]::Show('There are no Free VDIs in the pool', 'Free VDI issue', 'Ok', 'Hand')
        }
        else {
              $vdicount = Get-BrokerMachine -AssociatedUserName $DomainNameValue\$userNameValue -AdminAddress $ctxsrvnamevalue
              if (($vdicount)) {
                $result = [System.Windows.MessageBox]::Show('User already has a VDI. Do you wish to proceed?', 'VDI already exists', 'YesNo', 'Question')
                  if ($result -ne "No") {
                   $hostname = $VDIname.Split('.')[0]
                   Add-BrokerUser "$DomainNameValue\$usernamevalue" -PrivateDesktop "$DomainNameValue\$hostname" -AdminAddress $ctxsrvnamevalue
                   [System.Windows.MessageBox]::Show('VDI assigned successfully.', 'VDI assigned', 'Ok', 'Asterisk')
                  }
              }
              else {
                   $hostname = $VDIname.Split('.')[0]
                   Add-BrokerUser "$DomainNameValue\$usernamevalue" -PrivateDesktop "$DomainNameValue\$hostname" -AdminAddress $ctxsrvnamevalue
                   [System.Windows.MessageBox]::Show('VDI assigned successfully.', 'VDI assigned', 'Ok', 'Asterisk')
            }
        }
 
    }) 
$Form.Controls.Add($assignVDI)

#unassignVDI button
$unassignVDI = New-Object System.Windows.Forms.Button 
$unassignVDI.Location = New-Object System.Drawing.Size(160, 300) 
$unassignVDI.Size = New-Object System.Drawing.Size(130, 30) 
$unassignVDI.Text = "Unassign VDI" 
$unassignVDI.Add_Click( {

        $DomainNameValue = $DomainNametxtbx.text
        $userNameValue = $UserNameTxtBx.Text
        $ctxsrvnamevalue = $CtxSrvtxtbx.Text

        if ($DomainNameValue -like "*.*") {
            $DomainNameValue = $DomainNameValue.Split('.')[0]
        }

        $vdiassignedtoUser = Get-BrokerMachine -AssociatedUserName $DomainNameValue\$userNameValue -AdminAddress $ctxsrvnamevalue
        foreach ($vdi in $vdiassignedtoUser) { 
            $hostname = $VDI.dnsname.Split('.')[0]
            Remove-BrokerUser "$DomainNameValue\$usernamevalue" -PrivateDesktop "$DomainNameValue\$hostname" -AdminAddress $ctxsrvnamevalue
        }
        [System.Windows.MessageBox]::Show('VDI unassigned successfully.', 'VDI unassigned', 'Ok', 'Asterisk')
    }) 
$Form.Controls.Add($unassignVDI)

#ExitButton
$Exit = New-Object System.Windows.Forms.Button 
$Exit.Location = New-Object System.Drawing.Size(300, 300) 
$Exit.Size = New-Object System.Drawing.Size(130, 30) 
$Exit.Text = "Exit" 
$Exit.Add_Click( { $Form.Close() }) 
$Form.Controls.Add($Exit)

$Form.ShowDialog() | out-null
```
