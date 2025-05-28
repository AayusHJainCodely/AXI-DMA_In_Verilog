`timescale 1ns / 1ps

module tb_axi4_lite_ram;

    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 10;

    reg                       ACLK;
    reg                       ARESETN;

    reg  [ADDR_WIDTH-1:0]     AWADDR;
    reg                       AWVALID;
    wire                      AWREADY;

    reg  [DATA_WIDTH-1:0]     WDATA;
    reg  [(DATA_WIDTH/8)-1:0] WSTRB;
    reg                       WVALID;
    wire                      WREADY;

    wire [1:0]                BRESP;
    wire                      BVALID;
    reg                       BREADY;

    reg  [ADDR_WIDTH-1:0]     ARADDR;
    reg                       ARVALID;
    wire                      ARREADY;

    wire [DATA_WIDTH-1:0]     RDATA;
    wire [1:0]                RRESP;
    wire                      RVALID;
    reg                       RREADY;

    // Instantiate DUT
    axi4_lite_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .ACLK     (ACLK),
        .ARESETN  (ARESETN),
        .AWADDR   (AWADDR),
        .AWVALID  (AWVALID),
        .AWREADY  (AWREADY),
        .WDATA    (WDATA),
        .WSTRB    (WSTRB),
        .WVALID   (WVALID),
        .WREADY   (WREADY),
        .BRESP    (BRESP),
        .BVALID   (BVALID),
        .BREADY   (BREADY),
        .ARADDR   (ARADDR),
        .ARVALID  (ARVALID),
        .ARREADY  (ARREADY),
        .RDATA    (RDATA),
        .RRESP    (RRESP),
        .RVALID   (RVALID),
        .RREADY   (RREADY)
    );

    // Clock generation
    initial ACLK = 0;
    always #5 ACLK = ~ACLK;  // 100MHz clock

    // Reset sequence
    initial begin
        ARESETN = 0;
        #20;
        ARESETN = 1;
    end

    // Test sequence
    initial begin
        // Init
        AWADDR = 0;
        AWVALID = 0;
        WDATA = 0;
        WSTRB = 4'b1111;
        WVALID = 0;
        BREADY = 0;
        ARADDR = 0;
        ARVALID = 0;
        RREADY = 0;

        wait(ARESETN == 1);
        #20;

        // WRITE TRANSACTION
        @(posedge ACLK);
        AWADDR <= 10'h04;
        AWVALID <= 1;
        WDATA <= 32'hDEADBEEF;
        WVALID <= 1;
        WSTRB <= 4'b1111;

        @(posedge ACLK);
        while (!(AWREADY && WREADY)) @(posedge ACLK);
        AWVALID <= 0;
        WVALID <= 0;
        @(posedge ACLK);
        BREADY <= 1;
        @(posedge ACLK);
        BREADY <= 0;

        #20;

        // READ TRANSACTION
        @(posedge ACLK);
        ARADDR <= 10'h04;
        ARVALID <= 1;

        @(posedge ACLK);
        while (!ARREADY) @(posedge ACLK);
        ARVALID <= 0;

        @(posedge ACLK);
        RREADY <= 1;

        @(posedge ACLK);
        if (RVALID) begin
            $display("Read data: 0x%08X", RDATA);
            if (RDATA == 32'hDEADBEEF)
                $display("✅ PASS: Data match");
            else
                $display("❌ FAIL: Data mismatch");
        end
        RREADY <= 0;

        #20;
        $finish;
    end

endmodule
