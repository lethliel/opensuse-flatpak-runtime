# flatpak-runtime

A openSUSE Leap based runtime for [Flatpak](http://www.flatpak.org).

The scripts are based on the one from centos-flatpak-runtime.

For Leap 42.1

 * zypper addrepo -f http://download.opensuse.org/repositories/home:fcrozat:branches:openSUSE:Leap:42.1:Update/standard/home:fcrozat:branches:openSUSE:Leap:42.1:Update.repo
 * zypper --no-gpg-checks install -y flatpak
 * make

Install the Runtime and SDK

`
flatpak --user remote-add --no-gpg-verify opensuse /tmp/flat/exportrepo
flatpak --user install opensuse org.openSUSE.Runtime 1
flatpak --user install opensuse org.openSUSE.SDK 1
`


An examle manifest is placed under examples/screen/ and can be build with 
`
flatpak-builder --repo=/tmp/my_repo /tmp/build examples/screen/screen.manifest
`

The app screen is build and placed in the repository my_repo in tmp
Now we can install the app:

`
flatpak --user remote-add --no-gpg-verify opensuse_apps /tmp/my_repo
flatpak --user install opensuse_apps org.suse.screen
`

The next step is to run it: 

`
flatpak run org.suse.screen
`

And there you go. Feel free to contribute and comment. 

Happy hacking. 
