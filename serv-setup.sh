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
# 3. Appends to PATH the folder where fusesoc is installed () ~/.local/bin).
# 4. Creates workspace. If the workspace exists then it is moved (backed up)
#    to $WORKSPACE-$DATE.
# 5. Defines environement variables WORKSPACE and SERV
# 6. Runs fusesoc the clone fusesoc-cores and serv.
# 7. Creates aliases to simulate the pre-compiled examples. The aliases are:
#      run_hello, run_hello_mt, run_phil, run_sync, run_blinky
# 8. Prints a brief description of how to run the simulations.
#
# ===========================================================================

# Check if python3, pip3 and verilator are installed
install_list=""

ERR=0
python3=`which python3`
if [[ "$python3" = "" ]]; then
  echo "Error: Python3 not found"
  ERR=1
  install_list="$install_list python3"
fi

pip3=`which pip3`
if [[ "$pip3" = "" ]]; then
  echo "Error: Pip3 not found"
  ERR=2
  install_list="$install_list pip3"
fi

verilator=`which verilator`
if [[ "$verilator" = "" ]]; then
  echo "Warning: Verilator not found"
  install_list="$install_list verilator"
fi

if [[ "$install_list" != "" ]]; then
  echo "To install missing packages on Ubuntu:"
  echo "  sudo apt-get update> sudo apt-get install$install_list"
fi


# ----------------------------------------------------------------

if [[ $ERR -eq 0 ]]; then

# Append '.local/bin' to the path
PATH="$PATH:$HOME/.local/bin"

# Install fusesoc if not installed
fusesoc=`which fusesoc`
if [[ "$fusesoc" = "" ]]; then
  echo "Warning: fusesoc not found. Pip3 is installing it to '$HOME/.local/bin'"
  pip3 install fusesoc
fi

# Create SERV environement variables
WS="workspace"
if [[ "$1" != "" ]]; then
  WS="$1"
fi
PWD=$(pwd)
export WORKSPACE="$PWD/$WS"
export SERV=$WORKSPACE/fusesoc_libraries/serv
export SUBSERVIENT=$WORKSPACE/fusesoc_libraries/subservient

# Save old workspace if it exists
if [[ -d $WORKSPACE ]]; then
  NOW=$(date +"%Y_%m_%d-%H_%M_%S")
  SAVE_DIR="$WORKSPACE-$NOW"
  echo "Saving old workspace '$WORKSPACE' to '$SAVE_DIR'"
  mv $WORKSPACE $SAVE_DIR
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

echo "Success!"
echo "SERV and SUBSERVIENT are installed and ready for simulation"
echo "To run simulation:"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello.hex"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello_mt.hex --memsize=16384"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_phil.hex --memsize=32768"
echo "  fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_sync.hex --memsize=16384"
echo "  fusesoc run --target=verilator_tb servant --firmware=$SERV/sw/blinky.hex --memsize=16384"
echo "You can also use aliases: run_hello, run_hello_mt, run_phil, run_sync, run_blinky"
echo
alias run_hello='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello.hex'
alias run_hello_mt='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_hello_mt.hex --memsize=16384'
alias run_phil='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_phil.hex --memsize=32768'
alias run_sync='fusesoc run --target=verilator_tb servant --uart_baudrate=57600 --firmware=$SERV/sw/zephyr_sync.hex --memsize=16384'
alias run_blinky='fusesoc run --target=verilator_tb servant --firmware=$SERV/sw/blinky.hex --memsize=16384'

fi # endif not err

