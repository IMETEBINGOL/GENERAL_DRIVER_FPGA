// GENERAL TASKS
// ---
task goto;      
    input   [7:0]               state_t;
    begin
        cmd_state               <= state_t;
    end                 
endtask

task wait_and_goto;
    input   [7:0]               state_t;
    begin
        if (!spi_busy)
        begin
            cmd_state           <= state_t;
        end      
    end
endtask
// ---

// READ OPERATION 
// ---
task send_read_cmd_and_go;
    input   [PACKAGE_SIZE-1:0]  data_t;
    input   [PACKAGE_SIZE-2:0]  addr_t;
    input   [7:0]               state_t;
    begin
        spi_data                <= data_t;
        spi_addr                <= addr_t;
        spi_rw_op               <= HIGH;
        spi_send                <= HIGH;
        if (spi_busy)
        begin
            cmd_state           <= state_t;
        end
    end
endtask

task    wait_for_data_and_go;
    input   [7:0]               state_t;
    begin
        if(spi_data_ready && !spi_busy)
        begin
           data_return          <= spi_data_out;
           cmd_state            <= state_t;
        end
    end
endtask
// ---

