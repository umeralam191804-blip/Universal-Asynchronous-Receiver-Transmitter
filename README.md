# Universal-Asynchronous-Receiver-Transmitter
A parameterized UART (Universal Asynchronous Receiver/Transmitter) implementation in Verilog featuring separate Transmitter, Receiver, Baud Rate Generator, and Top modules with simulation testbench support

## Features
- UART Transmitter (TX)
- UART Receiver (RX)
- Configurable Baud Rate Generator
- Parameterized Data Width
- Modular Design Architecture
- Top-Level Integration Module
- Testbench for Functional Verification
- Compatible with ModelSim/QuestaSim simulation

## Project Structure

```
.
├── rtl
│   ├── uart_tx.v
│   ├── uart_rx.v
│   ├── baud_generator.v
│   └── uart_top.v
├── tb
│   └── tb_uart.v
├── docs
│   ├── block_diagram.png
│   └── waveform.png
├── README.md
├── LICENSE
└── .gitignore
```

## Applications
- FPGA-based communication systems
- Embedded Systems
- Serial Data Communication
- Digital Design Learning
- RISC-V Peripheral Integration

## Tools Used
- Verilog HDL
- ModelSim / QuestaSim
- Visual Studio Code

## Future Improvements
- Configurable parity modes (Even/Odd/None)
- Configurable stop bits
- FIFO support
- Error detection (Framing, Parity, Overrun)
- Hardware validation on FPGA
