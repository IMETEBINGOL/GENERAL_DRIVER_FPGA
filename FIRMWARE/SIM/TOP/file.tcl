proc collect_verilog_files {dir} {
    set files {}

    # Get all items in the directory
    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isfile $item] && [string match "*.v" $item]} {
            # If it's a .v file, add it to the list
            lappend files $item
        } elseif {[file isdirectory $item]} {
            # If it's a directory, recurse into it
            set subfiles [collect_verilog_files $item]
            set files [concat $files $subfiles]
        }
    }
    
    return $files
}


set SOURCE_FILES [collect_verilog_files "$HDL_DIRECTORY"]
set TESTBENCH_FILES [collect_verilog_files "$TESTBENCH_DIRECTORY"]

set GLOBAL_FILE C:/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v
set SOURCE_FILES_STR [join ${SOURCE_FILES} " "]
set TESTBENCH_FILES_STR [join ${TESTBENCH_FILES} " "]


