# HelloID-Conn-SA-Full-Exchange-On-Premises-Usermailbox-ActiveSync-Devices-Manage

| :information_source: Information                                                                                                                                                                                                                                                                                                                                                          |
| :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| This repository contains the connector and configuration code only. The implementer is responsible for acquiring the connection details such as username, password, certificate, etc. You might even need to sign a contract or agreement with the supplier before implementing this connector. Please contact the client's application manager to coordinate the connector requirements. |

## Description

_HelloID-Conn-SA-Full-Exchange-On-Premises-Usermailbox-ActiveSync-Devices-Manage_ is a template designed for use with HelloID Service Automation (SA) Delegated Forms. It can be imported into HelloID and customized according to your requirements.

By using this delegated form, you can manage ActiveSync device access for Exchange On-Premises user mailboxes. The following options are available:

1.  Search and select the user mailbox by entering a name, alias, or email address
2.  View all registered ActiveSync devices for the selected mailbox
3.  Move devices between available and blocked lists using the dual-list interface
4.  The form updates the device access state in Exchange On-Premises
5.  Devices can be activated (allowed) or blocked based on your selection

## Getting started

### Requirements

- **Exchange On-Premises Environment**:<br>
  An on-premises Exchange server environment with PowerShell remoting enabled is required.
- **Service Account with Permissions**:<br>
  A service account with sufficient permissions to manage mobile devices and CAS mailboxes in Exchange On-Premises. The account must have permissions to execute `Get-Mailbox`, `Get-MobileDevice`, and `Set-CASMailbox` cmdlets.
- **Network Connectivity**:<br>
  Network connectivity from the HelloID agent or server to the Exchange On-Premises PowerShell endpoint (typically http or https URI).
- **PowerShell Remoting**:<br>
  PowerShell remoting must be enabled and properly configured on the Exchange server.

### Connection settings

The following user-defined variables are used by the connector.

| Setting               | Description                                                | Mandatory |
| --------------------- | ---------------------------------------------------------- | --------- |
| ExchangeConnectionUri | The URI to the Exchange On-Premises PowerShell endpoint    | Yes       |
| ExchangeAdminUsername | The username of the service account to connect to Exchange | Yes       |
| ExchangeAdminPassword | The password of the service account to connect to Exchange | Yes       |

## Remarks

### Improved File Naming Convention

- All datasources and tasks now use a standardized naming convention with the connector prefix `exchange-on-premises-usermailbox-activesync-devices-manage` to improve clarity and organization.
- Configuration files (.config.json) are now included for all datasources to support better deployment and configuration management.

### Enhanced Security and Connection Management

- **TLS 1.2 Enforcement**: All scripts now explicitly enable TLS 1.2 for secure connections.
- **Modern Credential Handling**: Uses `[System.Management.Automation.PSCredential]::new()` for improved credential management.
- **Selective Command Import**: Only required Exchange cmdlets are imported, reducing memory footprint and improving performance.
- **Session Options**: Connection parameters now use splatting for better readability and maintenance.

### Improved Error Handling

- All scripts now include detailed error handling with line numbers and execution context through the `$actionMessage` pattern.
- Better structured try-catch blocks with specific error messages for easier troubleshooting.

### Terminology Consistency

- Updated from "Exchange On-Premise" to the correct term "Exchange On-Premises" throughout all resources.

### Dual List Configuration

- The dual list now uses clearer labels: "Available devices" (left) and "Blocked devices" (right).
- Fixed a bug in the old version where both device arrays incorrectly referenced `leftToRight`.

## Development resources

### PowerShell cmdlets

The following PowerShell cmdlets are used by the connector:

| Cmdlet           | Description                                                    |
| ---------------- | -------------------------------------------------------------- |
| Get-Mailbox      | Retrieve user mailbox information                              |
| Get-MobileDevice | Retrieve mobile device information for a mailbox               |
| Set-CASMailbox   | Update ActiveSync allowed and blocked device IDs for a mailbox |

### API documentation

For more information about Exchange On-Premises PowerShell cmdlets:

- [Connect to Exchange servers using remote PowerShell](https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-servers-using-remote-powershell)
- [Get-Mailbox](https://learn.microsoft.com/en-us/powershell/module/exchange/get-mailbox)
- [Get-MobileDevice](https://learn.microsoft.com/en-us/powershell/module/exchange/get-mobiledevice)
- [Set-CASMailbox](https://learn.microsoft.com/en-us/powershell/module/exchange/set-casmailbox)

## Getting help

> :bulb: **Tip:**  
> _For more information on Delegated Forms, please refer to our [documentation](https://docs.helloid.com/en/service-automation/delegated-forms.html) pages_.

## HelloID docs

The official HelloID documentation can be found at: https://docs.helloid.com/
