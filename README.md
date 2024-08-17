# Backup Script

[README](README.md) | [中文文档](README_zh.md)

This project contains a set of shell scripts that automate the process of backing up local and remote sources to local and remote targets. The scripts also handle the cleanup of old backups and provide logging for the backup process.

## Scripts

The project contains the following scripts:

- `env.sh`: Defines the configuration file path.
- `pre.sh`: Checks if backup is enabled and declares configuration variables.
- `run.sh`: Handles the backup process, including Docker interrupts, archiving local sources, and downloading and archiving remote sources.
- `after.sh`: Handles post-backup tasks, such as Docker interrupts, copying temporary sources to targets, cleaning up temporary files, and cleaning up expired sources from targets.
- `utils.sh`: Contains utility functions for reading values from the configuration file and logging.
- `fire.sh`: The main script that checks the environment, changes the working directory, and executes the other scripts in order.

## Configuration

The backup process can be configured through the `backup.properties` file. Here are the properties that can be set:

- `enable`: Whether the backup process is enabled.
- `tmp_dir`: The directory for temporary files during the backup process.
- `cleanup.min_file`: The minimum number of files to keep in the target directories.
- `cleanup.date`: The date for cleanup. Files older than this date will be cleaned up.
- `source.local.*`: The local sources to be backed up.
- `source.remote.*`: The remote sources to be backed up.
- `target.local.*`: The local targets where the backups will be stored.
- `target.remote.*`: The remote targets where the backups will be stored.
- `interrupt.enable`: Whether Docker interrupts are enabled.
- `interrupt.keyword.*`: The keywords for Docker interrupts.

## Usage

To use the backup script, follow these steps:

1. Clone the repository.
2. Configure the `backup.properties` file according to your needs.
3. Run the `fire.sh` script.

## Logs

The logs of the backup process are stored in the `logs` directory. Each log file is named with the date of the backup process. Logs older than 30 days are automatically deleted.

## Dependencies

The backup script requires the following tools:

- Bash
- pigz
- jq
- rclone

Please ensure these tools are installed before running the script.