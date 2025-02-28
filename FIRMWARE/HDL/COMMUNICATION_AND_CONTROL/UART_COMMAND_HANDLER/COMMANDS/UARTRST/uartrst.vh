`UARTRST_OPCODE:
begin
    case (command_state)
        COMMAND_INITIAL_STATE:
        begin
            goto(UART_RESET_PROCESS_0);
            uart_rst    <= HIGH;
        end
        UART_RESET_PROCESS_0:
        begin
            goto(UART_RESET_PROCESS_1);
        end
        UART_RESET_PROCESS_1:
        begin
            goto(UART_RESET_PROCESS_2);
        end
        UART_RESET_PROCESS_2:
        begin
            goto(UART_RESET_PROCESS_3);
            uart_rst    <= LOW;
        end
        UART_RESET_PROCESS_3:
        begin
            goto(UART_RESET_PROCESS_4);
        end
        UART_RESET_PROCESS_4:
        begin
            state_reset();
        end
        default:
        begin
            goto(COMMAND_INITIAL_STATE);
        end
    endcase
end 