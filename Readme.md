# Restic Backup

## Archived
I've moved on to using [Restic Scheduler](https://git.iamthefij.com/iamthefij/restic-scheduler)

## Instructions
Mount any directories you'd like to back up as a volume and run

## Env Variables
| Variable | Default | Description |
| -------- | ------- | ----------- |
|AWS_ACCESS_KEY_ID| |Required for writing to S3 or Minio|
|AWS_SECRET_ACCESS_KEY| |Required for writing to S3 or Minio|
|B2_ACCOUNT_ID| |Required for writing to B2|
|B2_ACCOUNT_KEY| |Required for writing to B2|
|BACKUP_DEST|/backups|Destination to store backups (See [restic documenation](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html))|
|CLEANUP_COMMAND| |Optional restic arguments for `forget` to execute after backups to clean older ones out (eg. "--prune --keep-last 2"). See [forget](https://restic.readthedocs.io/en/latest/060_forget.html)|
|CRON_SCHEDULE| |If you want to periodic incremental backups on a schedule, provide it here. By default we just backup once and exit|
|OPT_ARGUMENTS| |Any additional arguments to provide to the restic command|
|RESTIC_PASSWORD| |Passphrase to use for encryption|
|PATH_TO_BACKUP|/data|The path to the directory you wish to backup|
|RESTORE_ON_EMPTY_START| |Set this to "true" and if the `$PATH_TO_BACKUP` is empty, it will restore the latest backup. This can be used for auto recovery from lost data|
|SKIP_ON_START| |Skips backup on start if set to "true"|
|VERIFY_CRON_SCHEDULE| |If you want to verify your backups on a schedule, provide it here|

## Tips

## Hostnames
Hostname is used for identifying what you are backing up. You may want to specify this on your container.

### Backing up from another container
Mount all volumes from your existing container with `--volumes-from` and then back up by providing the paths to those volumes. If there are more than one volumes, you'll want to use the above tip for mulitple backup sources

### Restoring a backup
On your running container, execute `/scripts/restore.sh`. That should be that! Eg. `docker exec my_backup_container /scripts/restore.sh`

### Backup to any rclone destination
This image also contains [rclone](https://rclone.org). This allows you to target any destination supported by rclone. Check out the [official documentation](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#other-services-via-rclone) to see how to configure this.

Rather than having to use an exec shell inside the container, I recommend configuring via the backup destination. For example: `rclone::ftp,env_auth:/test-restic` and then passing all config values via the environment.

### Pre/post backup/restore scripts
Before and after any backup or restore, scripts located in `/scripts/{backup,restore}/{before,after}/` will be executed. This can be used to do things like snapshotting a database before backing it up and restoring the contents.
