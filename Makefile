arch ?= x86_64
kernel := target/kernel-$(arch).bin
iso := target/crab-os-$(arch).iso
bin-target := thumbv7em-none-eabihf

linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg
asm_src_files := $(wildcard src/arch/$(arch)/*.asm)
asm_obj_files := $(patsubst \
	src/arch/$(arch)/%.asm, \
	target/arch/$(arch)/%.o, \
	$(asm_src_files))

.PHONY: all clean run iso

all: $(kernel)

bin:
		cargo build --target $(bin-target)

clean:
		@rm -r target

run: $(iso)
		@qemu-system-x86_64 -cdrom $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
		@mkdir -p target/isofiles/boot/grub
		@cp $(kernel) target/isofiles/boot/kernel.bin
		@cp $(grub_cfg) target/isofiles/boot/grub
		@grub-mkrescue /usr/lib/grub/i386-pc -o $(iso) target/isofiles
		@rm -r target/isofiles

$(kernel): $(asm_obj_files) $(linker_script)
		@ld -n -T $(linker_script) -o $(kernel) $(asm_obj_files)

# compile assembly files
target/arch/$(arch)%.o: src/arch/$(arch)/%.asm
		@mkdir -p $(shell dirname $@)
		nasm -felf64 $< -o $@
