# serv-auto-setup

This repo has one script that automates the simulation of the ```SERV RISC-V
processor```, the award winning, world's smallest RISC-V CPU. The steps are 
from the SERV's README at: https://github.com/olofk/serv

To run the script:

```bash
git clone https://github.com/bustedwing1/serv-auto-setup
cd serv-auto-setup
source serv-setup.sh
```

The script accepts an optional argument that specifies the workspace name. The
default workspace name is ```workspace```.

```bash
source serv-setup.sh optional_custom_workspace_name
```

The serv-setup.sh script does the following:
--------------------------------------------

1. Checks if python3, pip3, verilator and iverilg (Icarus Verilog) are
   installed. It stops if python3 or pip3 are missing and warns if verilator
   or iverilog are not installed. It provides instructions on how to install
   the missing packages on Ubuntu.
2. Installs fusesoc (using pip3) if it is not installed.
3. Appends to PATH the folder where fusesoc is installed (```~/.local/bin```).
4. Creates workspace. If the workspace exists then it is moved (backed up)
   to ```$WORKSPACE-$DATE```.
5. Defines environement variables ```WORKSPACE``` and ```SERV```
6. Runs fusesoc to clone ```fusesoc-cores``` and ```serv```.
7. Creates aliases to simulate the pre-compiled examples. The aliases are:
     ```verilator_hello```, ```verilator_hello_mt```, ```verilator_phil```, ```verilator_sync``` and ```verilator_blinky```
     ```iverilog_hello```, ```iverilog_hello_mt```, ```iverilog_phil```, ```iverilog_sync``` and ```iverilog_blinky```
8. Prints a brief description of how to run the simulations.


Additional Notes
----------------

The following generates blinky.hex from the blinky.S assembly language program

```
cd $SERV/sw
make blinky.hex
```

or

```
cd $SERV/sw
/opt/riscv/bin/riscv32-unknown-linux-gnu-gcc -nostartfiles -nostdlib -march=rv32i -mabi=ilp32 -Tlink.ld -oblinky.elf blinky.S
/opt/riscv/bin/riscv32-unknown-linux-gnu-objcopy -O binary blinky.elf blinky.bin
python3 makehex.py blinky.bin > blinky.hex
fusesoc run --target=verilator_tb servant --firmware=blinky.hex --memsize=16384
```


Install Tool Chain
------------------

```bash
sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev \
	libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils \
	bc zlib1g-dev libexpat-dev
git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
mkdir ~/riscv-gnu-toolchain
./configure --prefix=~/riscv-gnu-toolchain/rv32i --with-arch=rv32i --with-abi=ilp32
make
echo "To add the toolchain to your path:"
echo "  export PATH=$PATH:~/riscv-gnu-toolchain/rv32i/bin"
``` 


