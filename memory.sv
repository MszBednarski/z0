// We set `OPERATION_FLAG` whenever we are performing a read or write on the chip
// with `OPERATION_FLAG` set we can either set `WRITE` to write `data` to `address`
// or we can set `READ` to read to `data` from `address`
// 16 bits word size
// we can store 2^16 - 1 values
// that gives 16 * ((2**16) - 1) bits of memory (1 MB)
module RAM(
// The address we are currently accessing as a 16 bit integer
    input [15:0] address, 
    input [15:0] data_i, 
    output [15:0] data_o,
    input OPERATION_FLAG, 
    input READ, 
    input WRITE
);

// the reg 'register' we store data in
reg [15:0] mem [0:(1 << 16) - 1];

// reading data
assign data_o = (OPERATION_FLAG && READ) ? mem[address] : 16'bz;

// writing data
always @(OPERATION_FLAG or WRITE) begin
    if (OPERATION_FLAG && WRITE) 
        mem[address] = data_i;
end

always @(WRITE or READ) begin
    if (WRITE && READ)
        $display("Operational error in RAM: READ and WRITE both active");
end
endmodule