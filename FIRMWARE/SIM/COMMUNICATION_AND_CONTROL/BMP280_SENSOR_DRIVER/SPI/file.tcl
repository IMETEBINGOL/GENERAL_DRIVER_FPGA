# glob => command is used to retrieve all files matching a pattern.
# -nocomplain => Prevents errors if the directory is empty or if no files match the pattern.
set SPI_VERILOG {}
foreach file [glob -nocomplain "${SPI_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend SPI_VERILOG $file
    }
}
set SPI_VERILOG_TESTBENCHS {}
foreach file [glob -nocomplain "${TESTBENCH_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend SPI_VERILOG_TESTBENCHS $file
    }
}
set GLOBAL_FILE C:/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v


set SPI_VERILOG_STR [join ${SPI_VERILOG} " "]
set SPI_VERILOG_TESTBENCHS_STR [join ${SPI_VERILOG_TESTBENCHS} " "]
