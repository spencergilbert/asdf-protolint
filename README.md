<div align="center">

# asdf-protolint [![Build](https://github.com/spencergilbert/asdf-protolint/actions/workflows/build.yml/badge.svg)](https://github.com/spencergilbert/asdf-protolint/actions/workflows/build.yml) [![Lint](https://github.com/spencergilbert/asdf-protolint/actions/workflows/lint.yml/badge.svg)](https://github.com/spencergilbert/asdf-protolint/actions/workflows/lint.yml)


[protolint](https://github.com/yoheimuta/protolint) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add protolint
# or
asdf plugin add protolint https://github.com/spencergilbert/asdf-protolint.git
```

protolint:

```shell
# Show all installable versions
asdf list-all protolint

# Install specific version
asdf install protolint latest

# Set a version globally (on your ~/.tool-versions file)
asdf global protolint latest

# Now protolint commands are available
protolint --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/spencergilbert/asdf-protolint/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Spencer Gilbert](https://github.com/spencergilbert/)
