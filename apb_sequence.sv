import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_base_seq extends uvm_sequence #(apb_item);
  `uvm_object_utils(apb_base_seq)

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit [31:0] temp_addr;
    apb_item req_write;
    apb_item req_read;

    for (int i = 0; i < 3; i++) begin
      req_write = apb_item::type_id::create("req_write");
      start_item(req_write);
      assert(req_write.randomize() with { write == 1'b1; });
      temp_addr = req_write.addr;
      finish_item(req_write);

      req_read = apb_item::type_id::create("req_read");
      start_item(req_read);
      assert(req_read.randomize() with { write == 1'b0; addr == temp_addr; });
      finish_item(req_read);
    end
  endtask

endclass