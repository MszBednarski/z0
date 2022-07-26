module RAM_tb();

// how to use inout:
// https://www.edaplayground.com/x/342E
// weird

logic [15:0] address;
logic [15:0] data_i;
logic [15:0] data_o;
logic OPERATION_FLAG, READ, WRITE;

// if we are in write mode assign 31337 else disconnect
// assign data_io = (WRITE) ? 16'd31337 : 16'bz;
RAM dut(address, data_i, data_o, OPERATION_FLAG, READ, WRITE); 
    initial begin
        // check what is at address 42
        address = 16'd42;
        OPERATION_FLAG = 1;
        READ = 1;
        WRITE = 0;
        #10;
        assert(data_o === 16'bx)
        else $error("Failed empty read %b", data_o);

        // try the non-active state
        OPERATION_FLAG = 0;
        READ = 0;
        WRITE = 0;
        #10;
        // we are not in write mode thus this should be 16'bz
        assert(data_o === 16'bz)
        else $error("Failed base %b", data_o);

        // try to write 31337 to address 42
        data_i = 16'd31337;
        OPERATION_FLAG = 1;
        READ = 0;
        WRITE = 1;
        #10;
        assert(data_i === 16'd31337)
        else $error("Failed to write %b", data_i);

        // lets read address 42
        data_i = 16'bx;
        // cancel write
        WRITE = 0;
        assert(data_o === 16'bz)
        else $error("Failed read precondition %b", data_o);
        // do a read at 42
        OPERATION_FLAG = 1;
        READ = 1;
        WRITE = 0;
        #10;
        assert(data_o === 16'd31337)
        else $error("Failed to read %b", data_o);
    end

always@(address, OPERATION_FLAG, READ, WRITE, data_i, data_o) begin
    $display("Time=%Dt address=%b data_i=%b data_o=%b OPERATION_FLAG=%b READ=%b WRITE=%b", $time, address, data_i, data_o, OPERATION_FLAG, READ, WRITE);
end
endmodule