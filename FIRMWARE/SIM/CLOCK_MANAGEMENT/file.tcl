# glob => command is used to retrieve all files matching a pattern.
# -nocomplain => Prevents errors if the directory is empty or if no files match the pattern.
set CLOCK_MANAGEMENT_VERILOG {}
foreach file [glob -nocomplain "${CLOCK_MANAGEMENT_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend CLOCK_MANAGEMENT_VERILOG $file
    }
}
set CLOCK_MANAGEMENT_VERILOG_TESTBENCHS {}
foreach file [glob -nocomplain "${TESTBENCH_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend CLOCK_MANAGEMENT_VERILOG_TESTBENCHS $file
    }
}
set GLOBAL_FILE C:/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v


set CLOCK_MANAGEMENT_VERILOG_STR [join ${CLOCK_MANAGEMENT_VERILOG} " "]
set CLOCK_MANAGEMENT_VERILOG_TESTBENCHS_STR [join ${CLOCK_MANAGEMENT_VERILOG_TESTBENCHS} " "]
