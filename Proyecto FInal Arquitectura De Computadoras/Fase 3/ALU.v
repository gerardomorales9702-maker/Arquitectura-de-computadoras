module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] sel,
    output reg [31:0] R,
    output Zero
);

    assign Zero = (R == 32'b0);

    always @(*) begin
        case (sel)
            4'b0000: R = A & B;
            4'b0001: R = A | B;
            4'b0010: R = A + B;
            4'b0110: R = A - B;
            4'b0111: R = (A < B) ? 32'd1 : 32'd0;
            4'b1100: R = ~(A | B);
            4'b0011: R = A ^ B;
            4'b0100: R = A << B[4:0];
            4'b0101: R = A >> B[4:0];
            default: R = 32'b0;
        endcase
    end

endmodule
