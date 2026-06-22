import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_driver extends uvm_driver #(apb_item);
  `uvm_component_utils(apb_driver)

  virtual apb_if vif;

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found")
    end
  endfunction
  virtual task run_phase(uvm_phase phase);
  wait(vif.presetn == 1'b1);
    forever begin
      seq_item_port.get_next_item(req);
      drive_transfer(req);
      seq_item_port.item_done();
    end
  endtask
  virtual task drive_transfer(apb_item req);
    @(posedge vif.pclk);
    vif.paddr   <= req.addr;
    vif.pwrite  <= req.write;
    vif.psel    <= 1'b1;
    vif.penable <= 1'b0;
    if(req.write) vif.pwdata <= req.data;

    @(posedge vif.pclk);
    vif.penable <= 1'b1;

    @(posedge vif.pclk);
    while(!vif.pready) @(posedge vif.pclk);

    if(!req.write) req.data = vif.prdata;

    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
  endtask

endclass