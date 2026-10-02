# Bakumugi Guix Channel

GNU Guix package definitions for software published by
[bakumugi777](https://github.com/bakumugi777).

The channel currently provides:

- `kaname`
- `shirube`
- `mio`

## Add the channel

Add this entry to your `channels.scm` alongside `%default-channels` and any
other channels you use:

```scheme
(channel
 (name 'bakumugi)
 (url "https://github.com/bakumugi777/guix-channel"))
```

Then update Guix:

```sh
guix pull -C channels.scm
```

Until the repository is published, a local checkout can be tested with:

```sh
guix build -L . -e '(@ (bakumugi packages desktop) kaname)'
guix build -L . -e '(@ (bakumugi packages desktop) shirube)'
guix build -L . -e '(@ (bakumugi packages mio) mio)'
```

## Install packages

After `guix pull`, the packages can be used like packages from any other
configured channel:

```sh
guix install kaname shirube mio
```

For a declarative Guix Home configuration:

```scheme
(packages
 (specifications->packages
  '("kaname" "shirube" "mio")))
```

Package definitions pin source revisions and hashes, so every channel commit
continues to describe the same sources. Updating an application means updating
its definition in this channel and publishing a new channel commit.

## Repository layout

```text
bakumugi/packages/desktop.scm       Kaname and Shirube
bakumugi/packages/mio.scm           Mio
bakumugi/packages/mio-Cargo.lock    Mio Rust dependencies
```

## License

The channel definitions are distributed under the GNU General Public License,
version 3 or later. Individual packaged projects retain their own licenses.
