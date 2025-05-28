module axi4_lite_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
    input  wire                     ACLK,
    input  wire                     ARESETN,

    // AXI4-Lite Write Address Channel
    input  wire [ADDR_WIDTH-1:0]    AWADDR,
    input  wire                     AWVALID,
    output wire                     AWREADY,

    // AXI4-Lite Write Data Channel
    input  wire [DATA_WIDTH-1:0]    WDATA,
    input  wire [(DATA_WIDTH/8)-1:0]WSTRB,
    input  wire                     WVALID,
    output wire                     WREADY,

    // AXI4-Lite Write Response Channel
    output wire [1:0]               BRESP,
    output wire                     BVALID,
    input  wire                     BREADY,

    // AXI4-Lite Read Address Channel
    input  wire [ADDR_WIDTH-1:0]    ARADDR,
    input  wire                     ARVALID,
    output wire                     ARREADY,

    // AXI4-Lite Read Data Channel
    output wire [DATA_WIDTH-1:0]    RDATA,
    output wire [1:0]               RRESP,
    output wire                     RVALID,
    input  wire                     RREADY
);

    reg [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];
    reg                  awready_reg, wready_reg, bvalid_reg, arready_reg, rvalid_reg;
    reg [DATA_WIDTH-1:0] rdata_reg;

    assign AWREADY = awready_reg;
    assign WREADY  = wready_reg;
    assign BVALID  = bvalid_reg;
    assign BRESP   = 2'b00; // OKAY

    assign ARREADY = arready_reg;
    assign RVALID  = rvalid_reg;
    assign RDATA   = rdata_reg;
    assign RRESP   = 2'b00; // OKAY

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            awready_reg <= 0;
            wready_reg  <= 0;
            bvalid_reg  <= 0;
            arready_reg <= 0;
            rvalid_reg  <= 0;
        end else begin
          
            if (AWVALID && !awready_reg)
                awready_reg <= 1;
            else
                awready_reg <= 0;

          
            if (WVALID && !wready_reg)
                wready_reg <= 1;
            else
                wready_reg <= 0;

       
            if (AWVALID && WVALID && !bvalid_reg) begin
                mem[AWADDR] <= WDATA;
                bvalid_reg <= 1;
            end else if (BREADY)
                bvalid_reg <= 0;

            if (ARVALID && !arready_reg)
                arready_reg <= 1;
            else
                arready_reg <= 0;

          
            if (ARVALID && !rvalid_reg) begin
                rdata_reg  <= mem[ARADDR];
                rvalid_reg <= 1;
            end else if (RREADY)
                rvalid_reg <= 0;
        end
    end
endmodule
