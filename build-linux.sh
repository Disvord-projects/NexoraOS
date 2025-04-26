GREEN='\033[32m'
NC='\033[0m'

LOGO='
  _   _                             ___  ____  
 | \ | | _____  _____  _ __ __ _   / _ \/ ___| 
 |  \| |/ _ \ \/ / _ \| '__/ _` | | | | \___ \ 
 | |\  |  __/>  < (_) | | | (_| | | |_| |___) |
 |_| \_|\___/_/\_\___/|_|  \__,_|  \___/|____/ 
'

echo -e "${GREEN}Compiling the bootloader${NC}"
nasm -f bin src/boot.asm -o bin/boot.bin

echo -e "${GREEN}Compiling the kernel and programs${NC}"
nasm -f bin src/kernel.asm -o bin/kernel.bin
nasm -f bin src/write.asm -o bin/write.bin
nasm -f bin src/snake.asm -o bin/snake.bin
nasm -f bin src/calc.asm -o bin/calc.bin

echo -e "${GREEN}Creating a disk image${NC}"
dd if=/dev/zero of=disk_img/x16pros.img bs=512 count=25

dd if=bin/boot.bin of=disk_img/x16pros.img conv=notrunc
dd if=bin/kernel.bin of=disk_img/x16pros.img bs=512 seek=1 conv=notrunc
dd if=bin/write.bin of=disk_img/x16pros.img bs=512 seek=8 conv=notrunc 
dd if=bin/snake.bin of=disk_img/x16pros.img bs=512 seek=15 conv=notrunc
dd if=bin/calc.bin of=disk_img/x16pros.img bs=512 seek=17 conv=notrunc
echo -e "${GREEN}Done.${NC}"

echo -e "${GREEN}${LOGO}${NC}"

echo -e "${GREEN}Launching QEMU...${NC}"
qemu-system-i386 -hda disk_img/x16pros.img
