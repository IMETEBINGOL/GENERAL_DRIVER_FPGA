`SPI_WRITE:
begin
    case (cmd_state)
        COMMAND_STATE_INITIAL:
        begin
            send_write_cmd_and_go(data_spi, addr_spi, COMMAND_WRITE_PROCESS_0);
        end
        COMMAND_WRITE_PROCESS_0:
        begin
            wait_and_goto(COMMAND_WRITE_PROCESS_1);
        end
        COMMAND_WRITE_PROCESS_1:
        begin
            goto(COMMAND_WRITE_PROCESS_2);
        end
        COMMAND_WRITE_PROCESS_2:
        begin
            state  <= CMDREAD;
        end 
        default:
        begin
            state  <= CMDREAD;
        end 
    endcase
end