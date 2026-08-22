#!/usr/bin/env bash
set -euo pipefail

# Public reproducibility recipe. This documents the kernel build stage only;
# boot-image repacking is device-format-specific and must be supplied by the
# matching Android boot-image tooling.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_SRC="${KERNEL_SRC:-${ROOT_DIR}/kernel-source}"
OUT_DIR="${OUT_DIR:-${ROOT_DIR}/build-out}"
CLANG_BIN="${CLANG_BIN:-clang}"

test -d "${KERNEL_SRC}" || { echo "KERNEL_SRC must point to the checked-out final kernel source" >&2; exit 2; }
mkdir -p "${OUT_DIR}"

make -C "${KERNEL_SRC}" O="${OUT_DIR}" ARCH=arm64 LLVM="${CLANG_BIN}" olddefconfig
make -C "${KERNEL_SRC}" O="${OUT_DIR}" ARCH=arm64 LLVM="${CLANG_BIN}" -j"${JOBS:-$(nproc)}" Image Image.lz4

echo "Built: ${OUT_DIR}/arch/arm64/boot/Image"
echo "Built: ${OUT_DIR}/arch/arm64/boot/Image.lz4"
echo "Repack the kernel with the exact tested Android boot v4 layout using external tooling."
