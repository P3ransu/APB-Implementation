import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  virtual apb_if vif;
  uvm_analysis_port #(apb_item) ap;

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    apb_item trans;
    forever begin
      @(posedge vif.pclk);
      if(vif.psel && vif.penable && vif.pready) begin
        trans = apb_item::type_id::create("trans");
        trans.addr  = vif.paddr;
        trans.write = vif.pwrite;
        if(vif.pwrite) begin
          trans.data = vif.pwdata;
        end else begin
          trans.data = vif.prdata;
        end
        ap.write(trans);
      end
    end
  endtask

endclass