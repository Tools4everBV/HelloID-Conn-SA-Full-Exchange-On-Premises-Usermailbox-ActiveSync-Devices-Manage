# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-08-27

### Added

- Added configuration files (.config.json) for all datasources to support better deployment and configuration management
- Added explicit TLS 1.2 enforcement to all scripts for improved security
- Added detailed error handling with line numbers and execution context using the `$actionMessage` pattern
- Added properties selection in datasources to limit memory usage and improve performance
- Added support for wildcard search across multiple fields (Name, SamAccountName, Alias, PrimarySmtpAddress) in mailbox datasource

### Changed

- Improved session connection management with parameter splatting for better readability
- Improved Exchange command import to only load required cmdlets (`Get-Mailbox`, `Get-MobileDevice`, `Set-CASMailbox`)

### Fixed

- Fixed inconsistent error handling and logging patterns across all scripts

### Removed

## [1.0.0] - 2023-07-04

Initial release of HelloID-Conn-SA-Full-Exchange-On-Premises-Usermailbox-ActiveSync-Devices-Manage.

### Added

- Initial release for managing ActiveSync devices for Exchange On-Premises user mailboxes
- Search and select user mailboxes by name or alias
- View and manage ActiveSync devices using dual-list interface
- Activate (allow) or block devices for selected mailboxes
