`SPI_READ:
begin
    case (cmd_state)
        COMMAND_STATE_INITIAL:
        begin
            send_read_cmd_and_go(addr_spi, COMMAND_READ_PROCESS_0);
        end
        COMMAND_READ_PROCESS_0:
        begin
            wait_for_data_and_go(COMMAND_READ_PROCESS_1);
        end
        COMMAND_READ_PROCESS_1:
        begin
            goto(COMMAND_READ_PROCESS_2);
        end
        COMMAND_READ_PROCESS_2:
        begin
            state  <= CMDREAD;
        end 
        default:
        begin
            state  <= CMDREAD;
        end 
    endcase
end