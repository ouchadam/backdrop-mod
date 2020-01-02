# backdrop-mod
Google backdrop without the Chromecast built in message, also kind of fixes the `home` integration, it's a bit flaky but working~.

### Prerequisites 

- [com.google.android.backdrop 1.4.4](https://play.google.com/store/apps/details?id=com.google.android.backdrop&hl=en_GB) 

### Usage

Using [apk-patcher](https://github.com/ouchadam/apk-patcher)

```
yarn global add apk-patcher
apk-patcher -i path/to/backdrop.apk -p path/to/dir/containing/patches
```

[Or standalone](https://github.com/ouchadam/backdrop-mod/tree/standalone)


### Deets

The script will decompile the given apk and apply the *.patch files then repackage, recompile and resign with a new key.

The backdrop apk is simply a wrapper around a webview which hits https://clients3.google.com/cast/chromecast/home?iv=atv
In the case of androidtv (chromecast built-in) all we need to do is remove the `iv=atv` parameter to remove the chromecast messaging.

However, there's also a local server for interacting with the `Google home` settings, without this server we end up stuck with only _featured photos_. Luckily the server is available it's just being blocked by the new android P security rules for clear text traffic, we can fix that by adding a domain allow rule for `localhost`
