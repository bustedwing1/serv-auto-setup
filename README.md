# serv-auto-setup

This repo has one script that automates some the initial steps in the SERV
README at: https://github.com/olofk/serv
To run the script:
 
```bash
source serv-setup.sh
```

OR

```bash
source serv-setup.sh optional_custom_workspace_name
```

if argument 'optional_custom_workspace_name' is not provided then the default
workspace name is 'workspace'.


The script does the following:
--------------------------------

1. Checks if python3, pip3 and verilator are installed. It stops if python3
   or pip3 are missing and warns if verilator is not installed. It provides
   instructions on how to install the missing packages on Ubuntu.
2. Installs fusesoc (using pip3) if it is not installed.
3. Appends to PATH the folder where fusesoc is installed (~/.local/bin).
4. Creates workspace. If the workspace exists then it is moved (backed up)
   to $WORKSPACE-$DATE.
5. Defines environement variables WORKSPACE and SERV
6. Runs fusesoc to clone fusesoc-cores and serv.
7. Creates aliases to simulate the pre-compiled examples. The aliases are:
     run_hello, run_hello_mt, run_phil, run_sync and run_blinky
8. Prints a brief description of how to run the simulations.


