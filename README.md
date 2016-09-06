# flatpak-runtime

An openSUSE Leap based runtime for [Flatpak](http://www.flatpak.org).

The scripts are based on the one from centos-flatpak-runtime.

For Leap 42.1

 * zypper install make gcc git kiwi
 * zypper addrepo -f http://download.opensuse.org/repositories/home:fcrozat:branches:openSUSE:Leap:42.1:Update/standard/home:fcrozat:branches:openSUSE:Leap:42.1:Update.repo
 * zypper --no-gpg-checks install -y flatpak flatpak-builder
 * git clone https://github.com/lethliel/opensuse-flatpak-runtime.git
 * cd opensuse-flatpak-runtime && make

Install the Runtime and SDK

```shell
flatpak --user remote-add --no-gpg-verify opensuse /tmp/flat/exportrepo
flatpak --user install opensuse org.openSUSE.Runtime 1
flatpak --user install opensuse org.openSUSE.Sdk 1
```

An examle manifest is placed under examples/screen.manifest and can be build with 
An even more complex manifest can be found under examples/complex.manifest (This one doesn't work yet but illustrates what can be done within a manifest) 

```shell
flatpak-builder --repo=/tmp/my_repo /tmp/build examples/screen.manifest
```

The app screen is build and placed in the repository my_repo in tmp
Now we can install the app:

```shell
flatpak --user remote-add --no-gpg-verify opensuse_apps /tmp/my_repo
flatpak --user install opensuse_apps org.suse.screen
```

The next step is to run it: 

```shell
flatpak run org.suse.screen
````

And there you go. Feel free to contribute and comment. 

Happy hacking. 
