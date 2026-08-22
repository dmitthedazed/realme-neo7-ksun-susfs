# Untracked integration source

The following exact source files/directories are present in the final build tree but are supplied by the pinned KernelSU Next/SUSFS revisions rather than duplicated in this metadata package:
drivers/kernelsu
fs/susfs.c
include/linux/susfs.h
include/linux/susfs_def.h
KernelSU-Next/

Recreate them by checking out the immutable revisions in SOURCES.md, then apply the patch series and tracked final-source.diff.
