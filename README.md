## Spotify installer README


This is an attempt to create something which installs the spotify
debian package[1]  in a distro independent way. The goal is to support
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
    $ cd leamas-spotfy-make-*
```

## Usage
/spotify-make.tar.gz

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
```
Installing in system directories e. g., installing in
/opt/local/lib and /opt/local/share with a binary in /usr/bin.
(yes, bad example, I know):
```
    $ ./configure  --prefix=/opt/local --bindir=/usr/bin
    $ make download
    # make install
    # make register
```
Installing in a temporary dir e. g. in a packaging context with all
sources already in place and the % substitutions available. The
--local flag disables downloading of any version data from spotify.
```
    $ env version=%{version} file=%{SOURCE1} \
    >   ./configure --prefix=/usr --libdir=%{_libdir} --local
    $ make install DESTDIR=/tmp/spotify
```
Other variants are possible using e. g. the --bindir or --libdir
arguments to configure. Use configure -h to find out. The register
target notifies system about new icons etc. There is also an
'uninstall' target.

This has so far only been tested on Fedora, so don't expect it to run out
of the box elsewhere. Time will tell if this is usable enough to get the
proper fixes for other distros. As of now, this is just an experiment.

## Dependencies

This is an installer, not a package. It has no automatic dependencies.
That said, the configure script tries to check the buildtime dependencies
and report missing items.

The Makefile tracks the runtime dependencies from spotify using ldd. It
tries to symlink to existing system libraries in simple cases. This is
reported as INFO: lines.

If there are unresolved runtime dependencies in spotify it's reported as
WARNING: lines.

## User installs

User installs have some caveats:

- The binary is by default in ~/bin. Your PATH must include this; this
  is a default setup on many (most? all?) distributions. Change with
  --bindir= to configure
- The desktop file  and icons are installed under ~/.local/share. This is
  according to opendesktop specs, and most tools will find them there. Perhaps
  not all, though. Change with --datadir= to ./configure.
- Manpage goes to ~/.local/share/man/man1. Your MANPATH will probably need
  an update to include  $HOME/.local/share/man. Change dir with --mandir=
  to ./configure. Manpage isn't that useful anyway.

## License

These files are in public domain, you can do whatever you like with them.
Remember that Spotify's own terms are unclear but ATM said to be
"non-redistributable, no changes permitted"


[1] http://community.spotify.com/t5/Desktop-Linux/bd-p/spotifylinux
