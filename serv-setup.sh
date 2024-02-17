# serv-setup.sh
# This script automates some the initial steps in the SERV README.
#    https://github.com/olofk/serv
#
# To Run:
# source serv-setup.sh
#     -- or --
# source serv-setup.sh optional_custom_workspace_name
#
# if 'optional_custom_workspace_name' is not provided then the default
# workspace name is 'workspace'.
#
# This scripts does the following:
# 1. Checks if python3, pip3 and verilator are installed. It stops if python3
#    or pip3 are missing and warns if verilator is not installed. It provides
#    instructions on how to install the missing packages on Ubuntu.
# 2. Installs fusesoc (using pip3) if it is not installed.
# 3. Appends to PATH the folder where fusesoc is installed (~/.local/bin).
# 4. Creates workspace. If the workspace exists then it is moved (backed up)
#    to $WORKSPACE-$DATE.
# 5. Defines environement variables WORKSPACE and SERV
# 6. Runs fusesoc to clone fusesoc-cores and serv.
# 7. Creates aliases to simulate the pre-compiled examples. The aliases are:
#      run_hello, run_hello_mt, run_phil, run_sync and run_blinky
# 8. Prints a brief description of how to run the simulations.
#
# ===========================================================================

# Check if python3, pip3, verilator and iverilog are installed
missing_packages=""

err_required_packages_are_missing=false
python3_is_installed=`which python3`
if [[ "$python3_is_installed" = "" ]]; then
  echo "Error: Python3 not found"
  err_required_packages_are_missing=true
  missing_packages="$missing_packages python3"
fi

pip3_is_installed=`which pip3`
if [[ "$pip3_is_installed" = "" ]]; then
  echo "Error: Pip3 not found"
  err_required_packages_are_missing=true
  missing_packages="$missing_packages pip3"
fi

verilator_is_installed=`which verilator`
if [[ "$verilator_is_installed" = "" ]]; then
  echo "Warning: Verilator not found"
  missing_packages="$missing_packages verilator"
fi

icarus_is_installed=`which iverilog`
if [[ "$icarus_is_installed" = "" ]]; then
  echo "Warning: Icarus Verilog (iverilog) not found"
  missing_packages="$missing_packages iverilog"
fi

if [[ "$missing_packages" != "" ]]; then
  echo "To install missing packages on Ubuntu:"
  echo "  sudo apt-get update> sudo apt-get install$missing_packages"
fi


# ----------------------------------------------------------------

if [[ $err_required_packages_are_missing -eq 0 ]]; then

# Append '.local/bin' to the path
PATH="$PATH:$HOME/.local/bin"

# Install fusesoc if not installed
fusesoc=`which fusesoc`
if [[ "$fusesoc" = "" ]]; then
  echo "Warning: fusesoc not found. Pip3 is installing it to '$HOME/.local/bin'"
  pip3 install fusesoc
fi

# Create SERV environement variables
ws="workspace"
if [[ "$1" != "" ]]; then
  ws="$1"
fi
pwd=$(pwd)
export WORKSPACE="$pwd/$ws"
export SERV=$WORKSPACE/fusesoc_libraries/serv
export SUBSERVIENT=$WORKSPACE/fusesoc_libraries/subservient

# Save old workspace if it exists
if [[ -d $WORKSPACE ]]; then
  now=$(date +"%Y_%m_%d-%H_%M_%S")
  backup_dir="$WORKSPACE-$now"
  echo "Saving old workspace '$WORKSPACE' to '$backup_dir'"
  mv $WORKSPACE $backup_dir
fi

# Created workspace and go into it
mkdir $WORKSPACE
cd $WORKSPACE

# Add SERV libraries
fusesoc library add fusesoc-cores https://github.com/fusesoc/fusesoc-cores
fusesoc library add serv https://github.com/olofk/serv
#fusesoc library add subservient https://github.com/olofk/subservient
fusesoc core show serv
fusesoc run --target=lint serv

# Create aliases to run the pre-compile tests

echo
echo "Success!"
echo "SERV is installed and ready for simulation"
echo "To run simulations with Verilator"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello.hex"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello_mt.hex --memsize=16384"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_phil.hex --memsize=32768"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_sync.hex --memsize=16384"
echo "  fusesoc run --target=verilator_tb servant --firmware=$SERV/sw/blinky.hex --memsize=16384"
echo "You can also use aliases: verilator_hello, verilator_hello_mt, verilator_phil, verilator_sync, verilator_blinky"
alias verilator_hello='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello.hex'
alias verilator_hello_mt='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello_mt.hex --memsize=16384'
alias verilator_phil='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_phil.hex --memsize=32768'
alias verilator_sync='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_sync.hex --memsize=16384'
alias verilator_blinky='fusesoc run --target=verilator_tb servant --firmware=$SERV/sw/blinky.hex --memsize=16384'

echo
echo "To run simulations with Icarus Verilog (iverilog)"
echo "  fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_hello.hex"
echo "  fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_hello_mt.hex --memsize=16384"
echo "  fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_phil.hex --memsize=32768"
echo "  fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_sync.hex --memsize=16384"
echo "  fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/blinky.hex --memsize=16384"
echo "You can also use aliases: run_hello, run_hello_mt, run_phil, run_sync, run_blinky"
alias iverilog_hello='fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_hello.hex'
alias iverilog_hello_mt='fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_hello_mt.hex --memsize=16384'
alias iverilog_phil='fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_phil.hex --memsize=32768'
alias iverilog_sync='fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/zephyr_sync.hex --memsize=16384'
alias iverilog_blinky='fusesoc run --target=sim --tool=icarus servant --firmware=$SERV/sw/blinky.hex --memsize=16384'

fi # endif not err

