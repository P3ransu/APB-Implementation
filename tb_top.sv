import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_top;

  logic pclk;
  logic presetn;

  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  initial begin
    presetn = 0;
    #20 presetn = 1;
  end
  apb_if vif (
    .pclk(pclk),
    .presetn(presetn)
  );

  apb_slave_dut dut (
    .pclk(vif.pclk),
    .presetn(vif.presetn),
    .paddr(vif.paddr),
    .psel(vif.psel),
    .penable(vif.penable),
    .pwrite(vif.pwrite),
    .pwdata(vif.pwdata),
    .prdata(vif.prdata),
    .pready(vif.pready),
    .pslverr(vif.pslverr)
  );
  
  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
    run_test("apb_test");
  end

endmodule
