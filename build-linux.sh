#!/bin/sh

# ============================================================================
# build-linux.sh — Build script for VinOS (floppy + ISO) and QEMU launch
# ============================================================================

# --- Configuration ---
OS_NAME="VinOS"

# --- Create directories if they don't exist ---
mkdir -p disk_images
mkdir -p boot # Ensure 'boot' directory exists for bootload.bin
mkdir -p src  # Ensure 'src' directory exists for kernel.bin

# --- Create floppy image if not exists ---
if [ ! -e "disk_images/${OS_NAME}.flp" ]; then
    echo ">>> Creating new floppy image: disk_images/${OS_NAME}.flp"
    mkdosfs -C disk_images/${OS_NAME}.flp 1440 || { echo "Error: Failed to create floppy image."; exit 1; }
fi

# --- Assemble bootloader ---
echo ">>> Assembling bootloader..."
nasm -f bin -o boot/bootload.bin boot/bootload.asm || { echo "Error: Bootloader assembly failed! Check boot/bootload.asm and permissions."; exit 1; }

# --- Assemble kernel ---
echo ">>> Assembling ${OS_NAME} kernel..."
nasm -f bin -o src/kernel.bin src/kernel.asm || { echo "Error: Kernel assembly failed! Check src/kernel.asm and permissions."; exit 1; }

# --- Write bootloader to floppy image (first 512 bytes) ---
echo ">>> Adding bootloader to floppy image..."
dd status=noxfer conv=notrunc if=boot/bootload.bin of=disk_images/${OS_NAME}.flp || { echo "Error: Failed to write bootloader to floppy image."; exit 1; }

# --- Copy kernel file to floppy image root directory ---
echo ">>> Copying ${OS_NAME} kernel to floppy image..."
mcopy -o -i disk_images/${OS_NAME}.flp src/kernel.bin ::/ || { echo "Error: Failed to copy kernel to floppy image."; exit 1; }


# --- Create ISO image from floppy ---
echo ">>> Creating ISO image..."
rm -f disk_images/${OS_NAME}.iso
mkisofs -quiet -V "${OS_NAME}" -input-charset iso8859-1 -o disk_images/${OS_NAME}.iso -b $(basename disk_images/${OS_NAME}.flp) disk_images/ || { echo "Error: Failed to create ISO image."; exit 1; }

echo ">>> ✅ Build complete! ISO ready at: disk_images/${OS_NAME}.iso"

# --- Boot VinOS from floppy image using QEMU ---
echo ">>> Booting ${OS_NAME} floppy image with QEMU..."

qemu-system-i386 \
    -drive format=raw,file=disk_images/${OS_NAME}.flp,index=0,if=floppy \
    -m 32M \
    -boot a \
    -cpu 486 \
    -no-reboot