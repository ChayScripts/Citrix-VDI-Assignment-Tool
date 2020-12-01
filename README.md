# Citrix-VDI-Assignment-Tool

Tool to assign a VDI to user or unassign all VDIs assigned to a user.

## Motivation

As a part of new user onboarding process, a request will be sent to Citrix team for new VDI creation and assignment. To offload this process to servicedesk/L1 team, they need a tool or script to do the same. So, I've created this tool. 

For new user onbording, service desk can assign a VDI and when a user leaves an organization, service desk can unassign all the VDIs assigned to that user. Citrix Admins job is to maintain free VDIs in the pool.

### Description

This tool will assign a VDI to user, or unassign all existing VDIs for a user.

### Prerequisites

* Citrix powershell modules are needed on the machine from which this tool is invoked.
* Should have permissions on Citrix Site to assign a VDI or unassign VDI.

### Installing

No installation required. This is standalone Tool. 

### Usage

Enter user name, citrix server name and domain name, and click "Get VDI Groups". This will show a dropdown with list of all available delivery gruops. Select a delivery group and click "Assign VDI" button. This will assign a free VDI from the pool to that user. Similarly, enter all details and click "Unassign VDI" button so that all the VDIs assigned to user will be unassigned.

### How does this tool work

This tool will:

* Assign a VDI to a user.
* Unassign all VDIs assigned to a user.

This tool will NOT:

* Add user's ID to delivery group's Active Directory group.
* Remove VDI from your hypervisor when "Unassign VDI" is used.

### Quick look at the tool

![Alt Text](https://github.com/TechScripts/Citrix-VDI-Assignment-Tool/blob/main/VDI%20Assignment%20Tool.PNG)

### Who can use

Preferably L1 or ServiceDesk team who is responsible for assigning VDIs for new users or unassigning VDIs when user leaves the organization.

### Built With

* [PowerShell](https://en.wikipedia.org/wiki/PowerShell) - Powershell
* [PS2EXE-GUI](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5) - Used to convert script to exe

### Authors

* **Tech Guy** - [TechScripts](https://github.com/TechScripts)

### Contributing

Please follow [github flow](https://guides.github.com/introduction/flow/index.html) for contributing.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
