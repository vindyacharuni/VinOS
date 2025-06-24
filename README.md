VinOS:
A 16-bit Assembly Operating System Kernel
VinOS is a custom 16-bit operating system kernel, written entirely in Assembly. It demonstrates fundamental low-level programming by directly interacting with system hardware using BIOS interrupts and CPU instructions.

Developed with NASM on Ubuntu Linux and designed to run in Oracle VirtualBox, VinOS offers a hands-on exploration of OS fundamentals, inspired by projects like MikeOS.

Features
Currently, VinOS provides a basic command-line interface with the following functionalities:

Custom Welcome Message: Displays a personalized welcome message upon booting.

Command Prompt: Presents a VinOS $ >> prompt for user interaction.

help Command: Lists available commands and system information.

clear Command: Clears the QEMU display screen.

Basic Keyboard Input: Reads and echoes typed characters.

Backspace Support: Allows correction of typed commands.

Command Parsing: Recognizes and executes simple, predefined commands.

Getting Started
Follow these steps to build VinOS and run it in QEMU on your Linux system.

Prerequisites
Ensure you have the following tools installed on your Ubuntu-based system:

nasm: The Netwide Assembler for assembling .asm files.

sudo apt install nasm


mkdosfs: From dosfstools, used to create the FAT12 floppy image.

sudo apt install dosfstools


dd: A core utility for converting and copying files (used for writing the bootloader).

sudo apt install coreutils


mtools: Provides utilities like mcopy for copying files to FAT-formatted images.

sudo apt install mtools


mkisofs (or genisoimage): For creating the ISO image.

sudo apt install genisoimage


qemu-system-i386: The QEMU emulator for i386 architecture to run the OS.

sudo apt install qemu-system-i386


Project Structure
Ensure your VinOS project directory is organized as follows:

VinOS/
├── build-linux.sh
├── disk_images/    (Will be created by the script)
├── boot/
│   └── bootload.asm  (Your bootloader assembly file)
└── src/
    └── kernel.asm    (Your kernel assembly file)


Build and Run Instructions
Clone or Download the Repository:
(If you are setting this up for the first time, make sure your files are in the VinOS directory as shown above.)

Navigate to the Project Directory:
Open your terminal and change to the root directory of your VinOS project (e.g., cd /media/vindya/sf_VinOS).

Make the Build Script Executable:

chmod +x build-linux.sh


Run the Build Script:
This script will assemble the bootloader and kernel, create the floppy and ISO images, and then automatically launch VinOS in QEMU.

sudo ./build-linux.sh


You will be prompted for your sudo password.

Interact with VinOS in QEMU:
A QEMU window will appear. After the initial boot messages, you should see the VinOS $ >> prompt.

Type help and press Enter to see available commands.

Type clear and press Enter to clear the screen.

Code Structure
boot/bootload.asm: The 16-bit bootloader responsible for initializing the system, reading the FAT12 filesystem, locating KERNEL.BIN, loading it into memory, and transferring control to the kernel.

src/kernel.asm: The main 16-bit kernel code. It handles screen output, keyboard input, basic command parsing (help, clear), and stays in an infinite loop waiting for commands.

build-linux.sh: A shell script that automates the entire build process (assembly, disk image creation) and launches the OS in QEMU.

Inspiration
This project draws inspiration from open-source operating system development projects, notably MikeOS, aiming to provide a clear and foundational understanding of OS principles.

Author
Vindya Charuni

License
This project is open-source and available under the MIT License. (You might want to create a LICENSE file in your repository with the full MIT license text.)
