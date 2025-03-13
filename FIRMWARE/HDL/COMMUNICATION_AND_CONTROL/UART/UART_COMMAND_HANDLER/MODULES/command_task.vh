task goto;
    input   [3:0] input_state;
    begin
        command_state   <= input_state;
    end
endtask

task state_reset;
    begin
        state           <= IDLE;
    end
endtask

task read_buffer;
    begin
        uart_out_read   <= HIGH;
    end
endtask

task read_buffer_goto;
    input [3:0] input_state;
    begin
        if (!uart_out_empty)
        begin
            uart_out_read   <= HIGH;
            command_state   <= input_state;
        end
        else
        begin
            command_state   <= command_state;
        end
    end
endtask

task write_buffer;
    input [BUFFER_WIDTH-1:0] data;
    begin
        uart_data_in    <= data;
        uart_in_write   <= HIGH;
    end
endtask

task write_settings;
    begin
        settings_write_en   <= HIGH;
    end
endtask
