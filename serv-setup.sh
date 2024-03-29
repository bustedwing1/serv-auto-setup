# serv-setup.sh
# This script setups of the variables for the serv workspace
# To Run:
# source serv-setup.sh
#     -- or --
# source serv-setup.sh optional_custom_workspace_name
#
# ===========================================================================

# Create SERV environement variables
ws="workspace"
if [[ "$1" != "" ]]; then
  ws="$1"
fi
pwd=$(pwd)
export WORKSPACE="$pwd/$ws"
export SERV=$WORKSPACE/fusesoc_libraries/serv

# Go into workspace
cd $WORKSPACE

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

