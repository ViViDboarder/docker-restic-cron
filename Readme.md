# Duplicity Backup

[![Build Status](https://travis-ci.org/ViViDboarder/docker-duplicity-cron.svg?branch=master)](https://travis-ci.org/ViViDboarder/docker-duplicity-cron)

## Instructions
Mount any directories you'd like to back up as a volume and run

## Env Variables
| Variable | Default | Description |
| -------- | ------- | ----------- |
|AWS_ACCESS_KEY_ID| |Required for writing to S3|
|AWS_DEFAULT_REGION| |Required for writing to S3|
|AWS_SECRET_ACCESS_KEY| |Required for writing to S3|
|BACKUP_DEST|file:///backups|Destination to store backups (See [duplicity documenation](http://duplicity.nongnu.org/duplicity.1.html#sect7))|
|BACKUP_NAME|backup|What the name for the backup should be. If using a single store for multiple backups, make sure this is unique|
|CLEANUP_COMMAND| |An optional duplicity command to execute after backups to clean older ones out (eg. "remove-all-but-n-full 2")|
|CRON_SCHEDULE| |If you want to periodic incremental backups on a schedule, provide it here. By default we just backup once and exit|
|FTP_PASSWORD| |Used to provide passwords for some backends. May not work without an attached TTY|
|FULL_CRON_SCHEDULE| |If you want to periodic full backups on a schedule, provide it here. This requires an incremental cron schedule too.|
|GPG_KEY_ID| |The ID of the key you wish to use. See [Encryption](#encryption) section below|
|OPT_ARGUMENTS| |Any additional arguments to provide to the duplicity backup command. These can also be provided as additional arguments via the command line|
|PASSPHRASE|Correct.Horse.Battery.Staple|Passphrase to use for GPG|
|PATH_TO_BACKUP|/data|The path to the directory you wish to backup. If you want to backup multiple, see the [tip below](#backing-up-more-than-one-source-directory)|
|RESTORE_ON_EMPTY_START| |Set this to "true" and if the `$PATH_TO_BACKUP` is empty, it will restore the latest backup. This can be used for auto recovery from lost data|
|SKIP_ON_START| |Skips backup on start if set to "true"|
|VERIFY_CRON_SCHEDULE| |If you want to verify your backups on a schedule, provide it here|

## Encryption
Add a ro mount to your `~/.gnupg` directory and then provide the `GPG_KEY_ID` as an environment variable. The key will be used to sign and encrypt your files before sending to the backup destination.

Need to generate a key? Install `gnupg` and run `gnupg --gen-key`

## Tips

### Missing dependencies?
Please file a ticket! Duplicity supports a ton of backends and I haven't had a chance to validate that all dependencies are present in the image. If something is missing, let me know and I'll add it

### Getting complains about no terminal for askpass?
Instead of using `FTP_PASSWORD`, add the password to the endpoint url

### Backing up more than one source directory
Duplicity only accepts one target, however you can refine that selection with `--exclude` and `--include` arguments. The below example shows how this can be used to select multiple backup sources
```
OPT_ARGUMENTS="--include /home --include /etc --exclude '**'"
PATH_TO_BACKUP="/"
```

### Backing up from another container
Mount all volumes from your existing container with `--volumes-from` and then back up by providing the paths to those volumes. If there are more than one volumes, you'll want to use the above tip for mulitple backup sources

### Restoring a backup
On your running container, execute `/restore.sh`. That should be that! Eg. `docker exec my_backup_container /restore.sh`

### To Do
 - [ ] Automatic restoration if there is no source data
