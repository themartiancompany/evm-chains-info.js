
[comment]: <> (SPDX-License-Identifier: AGPL-3.0)

[comment]: <> (----------------------------------------------------)
[comment]: <> (Copyright © 2024, 2025, 2026  Pellegrino Prevete)
[comment]: <> (All rights reserved)
[comment]: <> (----------------------------------------------------)

[comment]: <> (This program is free software: you can redistribute)
[comment]: <> (it and/or modify it under the terms of the GNU Affero)
[comment]: <> (General Public License as published by the Free)
[comment]: <> (Software Foundation, either version 3 of the License.)

[comment]: <> (This program is distributed in the hope that it will be)
[comment]: <> (useful, but WITHOUT ANY WARRANTY; without even the)
[comment]: <> (implied warranty of MERCHANTABILITY or FITNESS FOR A)
[comment]: <> (PARTICULAR PURPOSE.)

[comment]: <> (See the GNU Affero General Public License for more)
[comment]: <> (details. You should have received a copy of the GNU)
[comment]: <> (Affero License along with this program.)
[comment]: <> (If not, see <https://www.gnu.org/licenses/>.)
[comment]: <> (SPDX-License-Identifier: AGPL-3.0)

# EVM Chains Info (`evm-chains-info.js`)

[![NPM version](
  https://img.shields.io/npm/e/evmfs/evmfs.svg)](
    https://npmjs.org/package/evmfs)

Returns information about EVM chains.

```bash
  evm-chains-info.js \
    [options] \
    <target-chain>
```

This program is a dependency for the
[EVM Contracts Tools](
  https://github.com/themartiancompany/evm-contracts-tools)
and the [libEVM](
  https://github.com/themartiancompany/libevm)
library.

It is written and depends on the
[Crash Javascript](
  https://github.com/themartiancompany/crash-js)
library.

## Installation

The program in this source repo
can be installed from source using GNU Make.

```bash
make \
  install
```

It has officially published on the
the uncensorable
[Ur](
  https://github.com/themartiancompany/ur)
user repository and application store as
`evm-chains-info`.
The source code is published on the
[Ethereum Virtual Machine File System](
  https://github.com/themartiancompany/evmfs)
so it can't possibly be taken down.

To install it from there just type

```bash
ur \
  evm-chains-info
```

A censorable HTTP Github mirror of the recipe published there,
containing a full list of the software dependencies needed to run the
tools is hosted on
[evm-chains-info-ur](
  https://github.com/themartiancompany/encoding-tools-ur).
Be aware the mirror could go offline any time as Github and more
in general all HTTP resources are inherently unstable and censorable.

The package has also been published
on the NPM Registry as
[`evm-chains-info`](
  https://www.npmjs.com/package/evm-chain-info)
and so it can be installed from there by typing

```bash
npm \
  install \
    "evm-chains-info"
```

## License

This program is released by Pellegrino Prevete under the terms
of the GNU Affero General Public License version 3.
