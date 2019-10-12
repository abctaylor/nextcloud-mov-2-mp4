# An easy .mov converter for nextcloud
An automatic script to convert .mov files to .mp4 (or anything `ffmpeg` supports, e.g. .mkv), re-index the Nextcloud database and clean up afterwards

# Installation
1. Download `mov-2-mp4.sh` and place it somewhere on your nextcloud server
2. Make it executable: `chmod +x mov-2-mp4.sh`
3. Chown it so your web server can use it: `chown www-data:www-data mov-2-mp4.sh`
4. Edit www-data's crontab (so the script always runs in the background): `sudo crontab -u www-data -e`
5. Add the following to the crontab: `* * * * * /path/to/script/mov-to-mp4.sh` (this runs every minute: to run once a day at midnight, use `0 0 * * *` instead at the start)
6. (If you don't have it) download `ffmpeg`, e.g. `sudo apt install ffmpeg` (Ubuntu)

# Customising for your environment
Super simple - just change the four variables in the script:

|Variable|Default|Comment|
|---|---|---|
|`root_folder`|`/mnt/nextcloud`|Place where nextcloud keeps your stuff|
|`installation_path`|`/var/www/nextcloud/public_html`|Place where the web server keeps nextcloud source files, leave off last slash|
|`old_extension`|.mov|The old extension to convert from|
|`new_extension`|.mp4|The new extension to convert to|
|`safe_mode`|`true`| Renames .mov files as .mov-old, so you can recover (setting to `false` **deletes** .mov files permanently after conversion is done!)|
|`ignoregrep`|not set|Files to ignore for error messages - use if you have files that `find` would say "Permission denied" if it tried to scan - e.g. hidden folders that www-data is not permissioned for|

_Optional stuff_
* If you have postfix installed, you can add `MAILTO=mail@example.com` at the top of the crontab file to get notifications when this script processes something (it only sends mail when it finds something, so running it each minute with crontab `* * * * *` won't mail you each minute!)

