# variables configured in form
$mailbox = $form.selectedmailbox
$devicesToActivate = $form.devicelist.leftToRight
$devicesToBlock = $form.devicelist.leftToRight

# Global variables
# Outcommented as these are set from Global Variables
# $ExchangeConnectionUri = ""
# $ExchangeAdminUsername = ""
# $ExchangeAdminPassword = ""

# Fixed values
$commands = @(    
    "Set-CASMailbox"
)

# Enable TLS1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

# Set debug logging
$VerbosePreference = "SilentlyContinue"
$InformationPreference = "Continue"
$WarningPreference = "Continue"

#region functions
#endregion functions

try {
    # Create credentials
    $actionMessage = "creating credentials object"
    
    $securePassword = ConvertTo-SecureString -String $ExchangeAdminPassword -AsPlainText -Force
    $credential = [System.Management.Automation.PSCredential]::new($ExchangeAdminUsername, $securePassword)
    
    Write-Verbose "Created credentials for user [$ExchangeAdminUsername]"

    # Connect to Exchange On-Premises
    # Docs: https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-servers-using-remote-powershell
    $actionMessage = "connecting to Exchange On-Premises"

    $sessionOptionParams = @{
        SkipCACheck         = $false
        SkipCNCheck         = $false
        SkipRevocationCheck = $false
    }

    $sessionOption = New-PSSessionOption @sessionOptionParams

    $sessionParams = @{
        Authentication    = 'Default'
        ConfigurationName = 'Microsoft.Exchange'
        Credential        = $credential
        ConnectionUri     = $ExchangeConnectionUri
        SessionOption     = $sessionOption
        ErrorAction       = "Stop"
    }

    $exchangeSession = New-PSSession @sessionParams
    $null = Import-PSSession -Session $exchangeSession -DisableNameChecking -AllowClobber -CommandName $commands -ErrorAction Stop

    # Send initial audit log
    $Log = @{
        Action            = "UpdateResource" # optional. ENUM (undefined = default) 
        System            = "Exchange On-Premises" # optional (free format text) 
        Message           = "Successfully connected to Exchange using URI [$ExchangeConnectionUri]" # required (free format text) 
        IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
        TargetDisplayName = $ExchangeConnectionUri # optional (free format text) 
        TargetIdentifier  = $([string]$exchangeSession.InstanceId) # optional (free format text) 
    }
    Write-Information -Tags "Audit" -MessageData $log

    if ($devicesToActivate.count -gt 0) {
        $actionMessage = "activating devices"
        Write-Information "Starting to activate device [$($devicesToActivate.FriendlyName)] for user [$($mailbox.UserPrincipalName)]"
        
        foreach ($device in $devicesToActivate) {
            try {
                $activateActiveSyncDeviceParams = @{
                    Identity    = $($mailbox.UserPrincipalName)
                    ErrorAction = "Stop"
                }

                $null = Set-CASMailbox @activateActiveSyncDeviceParams -ActiveSyncAllowedDeviceIDs @{ add = $device.DeviceId }

                Write-Information "Finished activating $($device.DeviceId) for user [$($mailbox.UserPrincipalName)]"
                $Log = @{
                    Action            = "UpdateResource" # optional. ENUM (undefined = default) 
                    System            = "Exchange On-Premises" # optional (free format text) 
                    Message           = "Successfully activated $($device.DeviceId) for user [$($mailbox.UserPrincipalName)]" # required (free format text) 
                    IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
                    TargetDisplayName = $($mailbox.DisplayName) # optional (free format text) 
                    TargetIdentifier  = $($device.DeviceId) # optional (free format text) 
                }
                #send result back  
                Write-Information -Tags "Audit" -MessageData $log       
            }
            catch {
                Write-Error "Error activating $($device.DeviceId) for user [$($mailbox.UserPrincipalName)]. Error: $($_.Exception.Message)" 
                $Log = @{
                    Action            = "UpdateResource" # optional. ENUM (undefined = default) 
                    System            = "Exchange On-Premises" # optional (free format text) 
                    Message           = "Failed to activate [$($device.DeviceId)] for [$($mailbox.UserPrincipalName)]" # required (free format text) 
                    IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
                    TargetDisplayName = $($mailbox.DisplayName) # optional (free format text) 
                    TargetIdentifier  = $($device.DeviceId) # optional (free format text) 
                }
                #send result back  
                Write-Information -Tags "Audit" -MessageData $log                    
            }
        }        
    }

    if ($devicesToBlock.count -gt 0) {
        $actionMessage = "blocking devices"
        Write-Information "Starting to block device [$($devicesToBlock.FriendlyName)] for user [$($mailbox.UserPrincipalName)]"
        
        foreach ($device in $devicesToBlock) {
            try {
                $blockActiveSyncDeviceParams = @{
                    Identity    = $($mailbox.UserPrincipalName)
                    ErrorAction = "Stop"
                }

                $null = Set-CASMailbox @blockActiveSyncDeviceParams -ActiveSyncBlockedDeviceIDs @{ add = $device.DeviceId }

                Write-Information "Finished blocking $($device.DeviceId) for user [$($mailbox.UserPrincipalName)]"
                $Log = @{
                    Action            = "UpdateResource" # optional. ENUM (undefined = default) 
                    System            = "Exchange On-Premises" # optional (free format text) 
                    Message           = "Successfully blocked $($device.DeviceId) for user [$($mailbox.UserPrincipalName)]" # required (free format text) 
                    IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
                    TargetDisplayName = $($mailbox.DisplayName) # optional (free format text) 
                    TargetIdentifier  = $($device.DeviceId) # optional (free format text) 
                }
                #send result back  
                Write-Information -Tags "Audit" -MessageData $log       
            }
            catch {
                Write-Error "Error blocking $($device.DeviceId) for user [$($mailbox.UserPrincipalName)]. Error: $($_.Exception.Message)" 
                $Log = @{
                    Action            = "UpdateResource" # optional. ENUM (undefined = default) 
                    System            = "Exchange On-Premises" # optional (free format text) 
                    Message           = "Failed to block [$($device.DeviceId)] for [$($mailbox.UserPrincipalName)]" # required (free format text) 
                    IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
                    TargetDisplayName = $($mailbox.DisplayName) # optional (free format text) 
                    TargetIdentifier  = $($device.DeviceId) # optional (free format text) 
                }
                #send result back  
                Write-Information -Tags "Audit" -MessageData $log                    
            }
        }        
    }        
}
catch {
    $ex = $PSItem
    if (-not [string]::IsNullOrEmpty($ex.Exception.Message)) {
        $warningMessage = "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception.Message)"
        $auditMessage = "Error $($actionMessage). Error: $($ex.Exception.Message)"
    }
    else {
        $warningMessage = "Error at Line [$($ex.InvocationInfo.ScriptLineNumber)]: $($ex.InvocationInfo.Line). Error: $($ex.Exception)"
        $auditMessage = "Error $($actionMessage). Error: $($ex.Exception)"
    }

    # Send error audit log to HelloID
    $Log = @{
        Action            = "UpdateResource" # optional. ENUM (undefined = default) 
        System            = "Exchange On-Premises" # optional (free format text) 
        Message           = $auditMessage # required (free format text) 
        IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
        TargetDisplayName = $mailbox.DisplayName # optional (free format text) 
        TargetIdentifier  = $mailbox.ExchangeGuid # optional (free format text) 
    }
    
    Write-Information -Tags "Audit" -MessageData $log
    Write-Warning $warningMessage
    Write-Error $auditMessage
}
finally {
    # Disconnect from Exchange
    # Docs: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/remove-pssession
    if ($null -ne $exchangeSession) {
        try {
            $deleteExchangeSessionSplatParams = @{
                Session     = $exchangeSession
                Confirm     = $false
                ErrorAction = "Stop"
            }
            $null = Remove-PSSession @deleteExchangeSessionSplatParams

            # Send disconnect audit log
            $Log = @{
                Action            = "UpdateResource" # optional. ENUM (undefined = default) 
                System            = "Exchange On-Premises" # optional (free format text) 
                Message           = "Successfully disconnected from Exchange using URI [$ExchangeConnectionUri]" # required (free format text) 
                IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
                TargetDisplayName = $ExchangeConnectionUri # optional (free format text) 
                TargetIdentifier  = $([string]$exchangeSession.InstanceId) # optional (free format text) 
            }
            Write-Information -Tags "Audit" -MessageData $log
        }
        catch {
            Write-Warning "Failed to disconnect from Exchange using URI [$ExchangeConnectionUri]. Error: $($_.Exception.Message)"
        }
    }
}


