# glob => command is used to retrieve all files matching a pattern.
# -nocomplain => Prevents errors if the directory is empty or if no files match the pattern.





set SETTINGS_VERILOG {}
foreach file [glob -nocomplain "${SETTINGS_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend SETTINGS_VERILOG $file
    }
}
set SETTINGS_VERILOG_TESTBENCHS {}
foreach file [glob -nocomplain "${TESTBENCH_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend SETTINGS_VERILOG_TESTBENCHS $file
    }
}
set GLOBAL_FILE C:/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v


set SETTINGS_VERILOG_STR [join ${SETTINGS_VERILOG} " "]
set SETTINGS_VERILOG_TESTBENCHS_STR [join ${SETTINGS_VERILOG_TESTBENCHS} " "]