import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp #(apb_item, apb_scoreboard) item_export;
  bit [31:0] ref_mem [bit [31:0]];

  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
  endfunction
  
  virtual function void write(apb_item pkt);
    if (pkt.write) begin
      ref_mem[pkt.addr] = pkt.data;
    end else begin
      if (ref_mem.exists(pkt.addr)) begin
        if (ref_mem[pkt.addr] != pkt.data) begin
          `uvm_error("MISMATCH", $sformatf("Addr: %0h, Exp: %0h, Act: %0h", pkt.addr, ref_mem[pkt.addr], pkt.data))
        end else begin
          `uvm_info("MATCH", $sformatf("Addr: %0h, Data: %0h", pkt.addr, pkt.data), UVM_LOW)
        end
      end
    end
  endfunction
endclass