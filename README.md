# AXI DMA-Compatible Single-Port RAM (Verilog)

This project provides a basic Verilog implementation of a **single-port RAM** with an **AXI4-Lite memory-mapped interface**, intended for integration with an **AXI DMA controller** in FPGA designs.

---

## 🧱 Overview

The design consists of two main modules:

1. **`single_port_ram.v`**  
   A generic single-port RAM module with parameterizable data and address widths.

2. **`axi4_lite_ram.v`**  
   An AXI4-Lite slave wrapper that exposes the RAM to an AXI-Lite bus, allowing it to be read and written by an AXI master (e.g., DMA controller or processor).

This is useful for prototyping or for use in systems where custom memory-mapped regions are needed (such as testing AXI DMA transactions).

---

## 🔌 Interface Summary

### AXI4-Lite Slave

- **Write Channels**: `AWADDR`, `WDATA`, `WSTRB`, `WVALID`, `WREADY`, `BRESP`, `BVALID`
- **Read Channels**: `ARADDR`, `RDATA`, `RVALID`, `RREADY`, `RRESP`

### RAM

- Addressable via AXI addresses (use word-aligned addresses).
- Writes are performed on valid address and data handshakes.
- Reads are returned via the AXI read data channel.

---

## ⚙️ Parameters

Both modules allow customization through parameters:

- `DATA_WIDTH` (default: 32)
- `ADDR_WIDTH` (default: 10) — allows addressing `2^ADDR_WIDTH` words

---

## 🧪 Simulation

To test functionality:

1. Instantiate `axi4_lite_ram` in a testbench.
2. Apply AXI4-Lite read/write transactions.
3. Observe data being written into and read back from the RAM.

> A minimal testbench will be added soon.

---

## 🛠️ Integration Notes

- This RAM can be hooked up to **Xilinx Vivado AXI Interconnect** or used in custom SoC designs.
- Works well as a memory target for **AXI DMA (S2MM / MM2S)**.
- For burst-based AXI4 support, this wrapper needs to be extended (not included here).

---

## 📂 Files

- `single_port_ram.v` – Core RAM logic.
- `axi4_lite_ram.v` – AXI4-Lite interface wrapping the RAM.

---

## 🔄 Future Work

- AXI4 full (burst) interface
- AXI-Stream to RAM bridge
- Formal verification with SymbiYosys
- Example usage with Xilinx Zynq DMA

---

## 🧑‍💻 Author Notes

This is a personal utility project for working with AXI-based systems in FPGA development. Feel free to modify or extend it as needed.

If you find bugs or need AXI full burst support, feel free to open an issue or send a message.

---


