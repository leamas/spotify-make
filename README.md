## Spotify installer README

This is an attempt to create something which installs the spotify
debian package[1] in a distro independent way. The goal is to support
three usecases:

  - User-only install without root privileges.
  - System-wide FHS-compliant installs in e. g., /usr/local or /usr.
  - Temporary installs used in a packaging context.

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
target notifies system about new icons etc.  To uninstall the thing:
```
    $ cd "The $(datadir) used when installing"
    $ make uninstall
```
As of now, this is just an experiment, although there are succesful usacases
from Fedora, Ubuntu and SUSE. There are certainly fixes needed to stabilize
things though.

## Dependencies

This is an installer, not a package. It has no automatic dependencies.
That said, the configure script tries to check the buildtime dependencies
and report missing items.

The Makefile tracks the runtime dependencies from spotify using ldd. It
tries to symlink to existing system libraries in simple cases. This is
reported as INFO: lines.

Unresolved runtime dependencies in spotify is reported as WARNING: lines.

## User installs

User installs have some caveats:

- The binary is called my-spotify, to allow parallel install with a
  system-wide 'spotify' installation.
- The binary is by default installed in ~/bin.
- The desktop file  and icons are installed under ~/.local/share. This is
  according to opendesktop specs, and most tools will find them there.
- Some systems (notably Ubunt/unity) requires a logout-login sequence to
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
- Works occasionally. 32 and 64-bits minimally tested.
- Bundles the correct Debian libssl0.9.8.0.9.8o-4squeeze13.
- Desktop does not pick up the newly installed package until after logout-login.

### Fedora
- Solves the libssl0.9.8 problem by bundling.
- Works, both 64 and 32-bit.

### SUSE
- Current spec actually Conflicts libssl0.9.8, linking to 1.0.0 seems
  to work OK.
- Have some discussion about possible merging of spotify-make into current spec.

### Mageia
Package bundles libqtdbus4-4.8.1 required by spotify; system version is
4.8.2

## References

[1] http://community.spotify.com/t5/Desktop-Linux/bd-p/spotifylinux

[2] https://help.ubuntu.com/community/SwitchingToUbuntu/FromLinux/RedHatEnterpriseLinuxAndFedora

[3] https://wiki.archlinux.org/index.php/Pacman_Rosetta
