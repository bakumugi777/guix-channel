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
 (url "https://github.com/bakumugi777/guix-channel.git")
 (branch "main")
 (introduction
  (make-channel-introduction
   "4c2fd67736bc39da109f6a576bbc1a8555b497e7"
   (openpgp-fingerprint
    "0D7D C289 4AB5 E10E 94FC  B671 E24A F5CC 0C6E 7E45"))))
```

Then update Guix:

```sh
guix pull -C channels.scm
```

A local checkout can be tested without installing the channel with:

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
