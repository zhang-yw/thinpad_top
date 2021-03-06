`include "defines.v"

module id_ex(
    input wire rst,
    input wire clk,
    
    //input from id
    input wire[`AluOpBus] id_aluop,
    input wire[`AluSelBus] id_alusel,
    input wire[`RegBus] id_reg1,
    input wire[`RegBus] id_reg2,
    input wire[`RegAddrBus] id_wd,
    input wire id_wreg,
    input wire [`StallBus] stall_i,
    input wire[`RegBus] id_link_address,
	input wire id_is_in_delayslot,
	input wire next_inst_in_delayslot_i,	
    input wire[`RegBus] id_inst,	

    //output to ex
    output reg[`AluOpBus] ex_aluop,
    output reg[`AluSelBus] ex_alusel,
    output reg[`RegBus] ex_reg1,
    output reg[`RegBus] ex_reg2,
    output reg[`RegAddrBus] ex_wd,
    output reg ex_wreg,
    output reg[`RegBus] ex_link_address,
    output reg ex_is_in_delayslot,
	output reg is_in_delayslot_o,
    output reg[`RegBus] ex_inst,

    // exception handle
    input wire flush,
    input wire[`RegBus] excp_type_i,
    input wire[`RegBus] excp_inst_addr_i,
    output reg[`RegBus] excp_type_o,
    output reg[`RegBus] excp_inst_addr_o
      
);

    always @ (posedge clk) begin
        if (rst == `RstEnable || flush == 1) begin
            ex_aluop <= `EXE_SLL_OP;
            ex_alusel <= `EXE_RES_SHIFT;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
            ex_link_address <= `ZeroWord;
			ex_is_in_delayslot <= `NotInDelaySlot;
	        is_in_delayslot_o <= `NotInDelaySlot;
            ex_inst <= `ZeroWord;

            excp_type_o <= `ZeroWord;
            excp_inst_addr_o <= `ZeroWord;

        end else if (stall_i[2]==`Enable&&stall_i[3]==`Disable) begin
            ex_aluop <= `EXE_SLL_OP;
            ex_alusel <= `EXE_RES_SHIFT;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
            ex_link_address <= `ZeroWord;
	        ex_is_in_delayslot <= `NotInDelaySlot;
            ex_inst <= `ZeroWord;
            excp_type_o <= `ZeroWord;
            excp_inst_addr_o <= `ZeroWord;

        end else if (stall_i[2]==`Disable)begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;	
            ex_link_address <= id_link_address;
			ex_is_in_delayslot <= id_is_in_delayslot;
	        is_in_delayslot_o <= next_inst_in_delayslot_i;
            ex_inst <= id_inst;
            excp_type_o <= excp_type_i;
            excp_inst_addr_o <= excp_inst_addr_i;

        end
    end

endmodule
