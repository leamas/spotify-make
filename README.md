## Spotify installer README

This is an attempt to create something which installs the spotify
debian package[1] in a distro independent way. The goal is to support
three usecases:

  - User-only install without root privileges.
  - System-wide FHS-compliant installs in e. g., /usr/local or /usr.
  - Temporary installs used in a packaging context.

## News
#### 2015-06-29:
            Spotify has released a new 1.0.7.153 version. spotify-make
            has preliminary support for this. However, the application
            grabs the complete window, and there are no means whatsoever
            to minimize or exit. Use alt-F4 or similar window manager
            shortcuts to exit. Old version seems to still be around.
#### 2015-03-25:
            Spotify has released a new version 0.9.17.1.g9b85d43.7.Still
            no 32-bit support. There is some work needed to handle the
            new version, until that point spotify-make will not work. Stay
            tuned...

#### 2014-09-02:
	    Spotify has released a new version 0.9.11.27.g2b1a638c. There
            is still no 32-bit build, see below. According to preliminary
            tests spotify-make works out of the box with the new version.

#### 2014-05-26:
            Support for new version 0.9.10 available (64-bits hosts only,
            see below).

#### 2014-05-20:
            Preliminary support for 0.9.10 available in the devel branch.
            Note that this only builds 0.9.10 for x86_64 hosts, the i386
            code is stll at 0.9.4 - this depends on upstream which havn't
            built a i386 version at this point. Testing and bugs appreciated!

## Feedback

There is a forum thread on spotify-make at
http://community.spotify.com/t5/Help-Desktop-Linux-Mac-and/Linux-Installer-script-Ubuntu-SUSE-Mageia-Mint/m-p/240886

## Installation

Either use git:
```
    $ git clone  https://github.com/leamas/spotify-make.git
    $ cd spotify-make
```
or download a tarball and use that:
```
    $ wget https://github.com/leamas/spotify-make/tarball/master/spotify-make.tar.gz
    $ tar xzf spotify-make.tar.gz
    $ cd leamas-spotify-make-*
```

## Usage

Although not based on automake in any way it's run in the same way
using configure, make and make install. Some examples:

Making a user install without root privileges installs in
~/.local/share with a binary in ~/bin, downloading sources
as required:
```
    $ ./configure --user
    $ make download
    $ make install
    $ make register
    $ ~/bin/my-spotify
```
Installing in system directories e. g., installing in /opt/local/lib and
/opt/local/share with a binary in /usr/bin. (yes, bad example, I know):
```
    $ ./configure  --prefix=/opt/local --bindir=/usr/bin
    $ make download
    # make install
    # make register
    $ spotify
```
Installing in a temporary dir e. g. in a packaging context with all
sources already in place and the % substitutions available. The
--package flag disables downloading of any data from spotify.
```
    $ ./configure --prefix=/usr --libdir=%{_libdir} --package=%{SOURCE1}
    $ make install DESTDIR=/tmp/spotify
```
Other variants are possible using e. g. the --bindir or --libdir
arguments to configure. Use configure -h to find out. The register
target notifies system about new icons etc. To uninstall the thing:
```
    $ cd "The $(datadir) used when installing"
    $ make uninstall
```
As of now, this is just an experiment although there are successful usecases
from Fedora, Ubuntu, Mageia and SUSE. There are certainly fixes needed to
stabilize things though.

## Dependencies

This is an installer, not a package. It has no automatic dependencies.
That said, the configure script tries to check the buildtime dependencies
and reports them as ERROR e. g.,
```
   $ ./configure --user
   Checking build and support dependencies
       ...
       make: ERROR: Not found
```
You are on your own here: you must find out the package which provides
make and install it.

The Makefile tracks the runtime dependencies from spotify using ldd. It
tries to symlink to existing system libraries in simple cases. This is
reported as INFO: lines. Unresolved runtime dependencies in spotify is
reported as WARNING: lines e. g.:
```
    $ make install
    ...
    WARNING; cant resolve spotify dependency: libQtGui.so.4
```
Likewise, here you have to find the package providing libQtGui.so.4
and install it.

## User installs

User installs have some caveats:

- The binary is called my-spotify, to allow parallel install with a
  system-wide 'spotify' installation.
- The binary is by default installed in ~/bin.
- The desktop file  and icons are installed under ~/.local/share. This is
  according to freedesktop specs, and most tools will find them there.
- Some systems (notably Ubuntu/unity) requires a logout-login sequence to
  pickup the installation in the menus.
- Manpage goes to ~/.local/share/man/man1. Your MANPATH will probably need
  an update to include  $HOME/.local/share/man. Change dir with --mandir=
  to ./configure. Manpage isn't that useful anyway.

## License

These files are in public domain, you can do whatever you like with them.
Remember that Spotify's own terms are unclear but ATM said to be
"non-redistributable, no changes permitted"

## System notes

### Ubuntu
- Works occasionally. 12.10 32- and 64-bits minimally tested.
  13.10 success stories reported.
- Bundles the correct Debian libssl0.9.8.0.9.8o-4squeeze13.
- Desktop (unity) does not pick up the newly installed package until
  after logout-login.

### Fedora
- Solves the libssl0.9.8 problem by bundling.
- Works, both 64 and 32-bit.

### SUSE
- Current spec actually Conflicts libssl0.9.8, linking to 1.0.0 seems
  to work OK.
- Have some discussion about possible merging of spotify-make into current spec
  and installer, a fork is available [7].
- 32-bit release 12.2 and upcoming 12.3 (Factory) minimally tested.

### Mageia
Minimally tested on version 2, 32-bit desktop release. Package bundles
libqtdbus4-4.8.1 required by spotify; system version is 4.8.2

### Debian
- Success stories reported for Wheezy 7.0, bug fixed for 7.1 (issue #13)

### CentOS
- Partial success story on CentOS 6.4 in [6]

### Linux Mint
Handled the same way as Ubuntu. Version 14 32-bit minimally tested.

## References

[1] http://community.spotify.com/t5/Help-Desktop-Linux-Mac-and/bd-p/001

[2] https://help.ubuntu.com/community/SwitchingToUbuntu/FromLinux/RedHatEnterpriseLinuxAndFedora

[3] https://wiki.archlinux.org/index.php/Pacman_Rosetta

[4] https://bugs.launchpad.net/ubuntu/+source/desktop-file-utils/+bug/592671

[5] https://bugs.launchpad.net/ubuntu/+source/meta-gnome2/+bug/572918

[6] http://community.spotify.com/t5/Help-Desktop-Linux-Mac-and/Linux-Installer-script-Ubuntu-SUSE-Mageia-Mint/m-p/240886/highlight/true#M8789

[7] https://github.com/leamas/opensuse-spotify-installer
