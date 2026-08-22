# Redistribution audit

## KernelSU Next Manager

Decision: **NO — not bundled**.

The local APK is a signed binary. KernelSU Next documents GPL-3.0-or-later for
non-kernel files and GPL-2.0-only for its kernel directory, but this package
does not bundle the APK because its complete binary dependency/signing and
redistribution context was not independently audited. Use the official
project/release page:

https://github.com/KernelSU-Next/KernelSU-Next

## SUSFS userspace

Decision: **NO — not bundled**.

The local ZIP is a third-party binary/module artifact. SUSFS is GPLv3-or-later,
but the package does not silently redistribute the ZIP. Use the exact upstream
repository and compatible commit listed in `source/SOURCES.md`:

https://gitlab.com/simonpunk/susfs4ksu

## Kernel and patches

The kernel source is GPL-licensed as documented by the upstream kernel COPYING
file. KernelSU/SUSFS source notices and the local patch set are supplied in the
source package. WildKernels is credited as a reference/patch source; no
separate permissive license file was found in the local reference checkout, so
the audit is intentionally marked PARTIAL rather than overstated.

Overall audit status: **PARTIAL**.
