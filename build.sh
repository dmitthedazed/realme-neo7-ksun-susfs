#!/usr/bin/env bash
set -euo pipefail

# Builds the kernel Image from a prepared source tree (see README).
# Repacking it into a boot image is left to Android boot-image tooling.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
KERNEL_SRC="${KERNEL_SRC:-${ROOT_DIR}/kernel-source}"
OUT_DIR="${OUT_DIR:-${ROOT_DIR}/build-out}"
CLANG_BIN="${CLANG_BIN:-clang}"
CONFIG="${SCRIPT_DIR}/config/RMX5060_6.1.157_KSUN-SUSFS.config"

test -d "${KERNEL_SRC}" || { echo "KERNEL_SRC must point to the prepared kernel source" >&2; exit 2; }
mkdir -p "${OUT_DIR}"
cp "${CONFIG}" "${OUT_DIR}/.config"

make -C "${KERNEL_SRC}" O="${OUT_DIR}" ARCH=arm64 LLVM="${CLANG_BIN}" olddefconfig
make -C "${KERNEL_SRC}" O="${OUT_DIR}" ARCH=arm64 LLVM="${CLANG_BIN}" -j"${JOBS:-$(nproc)}" Image Image.lz4

echo "Built: ${OUT_DIR}/arch/arm64/boot/Image"
echo "Built: ${OUT_DIR}/arch/arm64/boot/Image.lz4"
