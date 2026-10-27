<div align="center">

# realme Neo7 · KernelSU Next + SUSFS

Kernel source for **realme Neo7 (RMX5060)** with root via KernelSU Next and root hiding via SUSFS.

![Kernel](https://img.shields.io/badge/kernel-6.1.157-informational)
![KernelSU Next](https://img.shields.io/badge/KernelSU_Next-v3.3.0-success)
![SUSFS](https://img.shields.io/badge/SUSFS-v2.2.0-success)
![Status](https://img.shields.io/badge/status-tested-yellow)

</div>

> [!WARNING]
> Unofficial and not stable. It was tested on one phone with one firmware. Flashing a kernel can leave your phone unable to boot, so back up your stock boot image first and know how to restore it with fastboot.

## Target

| | |
| --- | --- |
| Device | realme Neo7, `RMX5060` |
| Firmware | `RMX5060_16.0.9.400(CN01)`, Android 16, security patch 2026-07-01 |
| Kernel | `6.1.157-android14-11`, KMI `android14-6.1-11` |

Other firmware versions most likely won't boot with this kernel.

## What you get

- **KernelSU Next** root, managed by the [KernelSU Next app](https://github.com/KernelSU-Next/KernelSU-Next/releases).
- **SUSFS** hides root from apps and integrity checks:
  - hidden paths, mounts and file stats
  - spoofed `uname`, kernel cmdline and bootconfig
  - open redirects and hidden memory maps
  - KernelSU and SUSFS symbols hidden from `kallsyms`

To control SUSFS from userspace, install its module from [susfs4ksu](https://gitlab.com/simonpunk/susfs4ksu).

## Sources

Every component is pinned to an exact commit. The same values are in [`versions.lock`](versions.lock).

| Component | Version | Commit |
| --- | --- | --- |
| [Kernel](https://github.com/OnePlusOSS/android_kernel_oneplus_mt6989) (OnePlus MT6989) | | `822beed` |
| [KernelSU Next](https://github.com/KernelSU-Next/KernelSU-Next) | v3.3.0 | `3b18216` |
| [SUSFS](https://gitlab.com/simonpunk/susfs4ksu) | v2.2.0 | `0ff9327` |
| [WildKernels](https://github.com/WildKernels/OnePlus_KernelSU_SUSFS) patches | v2.2.0-r4 | `d442403` |

## Build

You need a Linux machine with clang/LLVM and the usual kernel build tools. Run everything from the folder that contains this repo:

```sh
git clone https://github.com/dmitthedazed/realme-neo7-ksun-susfs
```

**1. Kernel source with all changes applied**

```sh
git clone https://github.com/OnePlusOSS/android_kernel_oneplus_mt6989 kernel-source
git -C kernel-source checkout 822beed40827f1e9a103bc06ab4714a670080b72
git -C kernel-source apply ../realme-neo7-ksun-susfs/patches/final-source.diff
```

**2. KernelSU Next with the compatibility patches**

```sh
git clone https://github.com/KernelSU-Next/KernelSU-Next kernel-source/KernelSU-Next
git -C kernel-source/KernelSU-Next checkout v3.3.0
for p in $(cat realme-neo7-ksun-susfs/patches/SERIES); do
  git -C kernel-source/KernelSU-Next apply "$PWD/realme-neo7-ksun-susfs/patches/wildkernels-ksun-susfs-2.2/$p"
done
ln -s ../KernelSU-Next/kernel kernel-source/drivers/kernelsu
```

**3. SUSFS sources**

```sh
git clone https://gitlab.com/simonpunk/susfs4ksu susfs
git -C susfs checkout 0ff932799d898366d57b3b5984d85cdbcfcfad0a
cp susfs/kernel_patches/fs/susfs.c kernel-source/fs/
cp susfs/kernel_patches/include/linux/susfs*.h kernel-source/include/linux/
```

**4. Build**

```sh
KERNEL_SRC=$PWD/kernel-source ./realme-neo7-ksun-susfs/build.sh
```

It uses the config from [`config/`](config) and writes `Image` and `Image.lz4` to `build-out/arch/arm64/boot/`. Put the image into your stock boot image with a tool like `magiskboot`, then flash it.

The compiler version wasn't recorded, so the result matches the tested build in source, not byte for byte.

<details>
<summary>Repository layout</summary>

```text
build.sh                build the kernel image
versions.lock           device, firmware and pinned versions
config/                 final kernel config
patches/
  final-source.diff     all changes to the base kernel
  SERIES                order of the KernelSU Next patches
  wildkernels-*/        KernelSU Next compatibility patches
licenses/               GPL and upstream license texts
```

</details>

## Licenses

The kernel is GPL-2.0. KernelSU Next is GPL-2.0 in its kernel part and GPL-3.0-or-later elsewhere. SUSFS is GPL-3.0-or-later. Texts are in [`licenses/`](licenses).

The KernelSU Next app and the SUSFS module aren't bundled here, get them from upstream. No stock firmware, backups or personal data are included.

## Credits

[KernelSU Next](https://github.com/KernelSU-Next/KernelSU-Next) · [SUSFS by simonpunk](https://gitlab.com/simonpunk/susfs4ksu) · [WildKernels](https://github.com/WildKernels/OnePlus_KernelSU_SUSFS) · [OnePlusOSS](https://github.com/OnePlusOSS)
