
## Run this script from SERV's workspace

sed -i 's/VERILOG_TEMPLATE/MY_SERV_CAPE/g' ../beaglev-fire/my_custom_fpga_design.yaml
cp -rf ../../sources/FPGA-design/script_support/components/CAPE/VERILOG_TEMPLATE ../../sources/FPGA-design/script_support/components/CAPE/MY_SERV_CAPE
cp ../beaglev-fire/ADD_CAPE.tcl  ../../sources/FPGA-design/script_support/components/CAPE/MY_SERV_CAPE/ADD_CAPE.tcl
sed -i 's/VERILOG_TEMPLATE/MY-SERV_CAPE/g' ../../sources/FPGA-design/script_support/components/CAPE/MY_SERV_CAPE/device-tree-overlay/verilog-cape.dtso

sed -i 's#zephyr_hello.hex#../../blinky.hex#' fusesoc_libraries/serv/servant/servant.v
sed -i 's#`default_nettype#// `default_nettype#' fusesoc_libraries/serv/servant/*.v
verilator_blinky

cp -rf build/servant_1.2.1/verilator_tb/src/serv_1.2.1 ../../sources/FPGA-design/script_support/components/CAPE/MY_SERV_CAPE/HDL
cp -rf build/servant_1.2.1/verilator_tb/src/servant_1.2.1 ../../sources/FPGA-design/script_support/components/CAPE/MY_SERV_CAPE/HDL
cp -rf build/servant_1.2.1/verilator_tb/src/servile_1.3.0 ../../sources/FPGA-design/script_support/components/CAPE/MY_SERV_CAPE/HDL
cp fusesoc_libraries/serv/sw/blinky.hex ../..

