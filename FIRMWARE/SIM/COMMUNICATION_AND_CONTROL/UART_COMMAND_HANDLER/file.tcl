# glob => command is used to retrieve all files matching a pattern.
# -nocomplain => Prevents errors if the directory is empty or if no files match the pattern.
set UART_COMMAND_HANDLER_VERILOG {}
foreach file [glob -nocomplain "${UART_COMMAND_HANDLER_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend UART_COMMAND_HANDLER_VERILOG $file
    }
}


set UART_COMMAND_HANDLER_VERILOG_TESTBENCHS {}
foreach file [glob -nocomplain "${TESTBENCH_DIRECTORIES}/*"] {
    if {![file isdirectory $file]} {
        lappend UART_COMMAND_HANDLER_VERILOG_TESTBENCHS $file
    }
}


set GLOBAL_FILE C:/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v
set UART_COMMAND_HANDLER_VERILOG_STR [join ${UART_COMMAND_HANDLER_VERILOG} " "]
set UART_COMMAND_HANDLER_VERILOG_TESTBENCHS_STR [join ${UART_COMMAND_HANDLER_VERILOG_TESTBENCHS} " "]