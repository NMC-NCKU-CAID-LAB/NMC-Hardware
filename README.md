# Verilog-Project-NMC

  Contributor:
<a href="https://github.com/DarrenHuang0411/Project-NMC-Hardware/graphs/contributors">
<img src="https://contrib.rocks/image?repo=DarrenHuang0411/Project-NMC-Hardware" />
</a>

## Environment

  > [!IMPORTANT]
  >
  > | Tool | Version  |
  > | :----: | :----: |
  > | Vivado | 2019.1 |
  > | SDK    | 2019.1 |
  > | Board  | below  |
  >
  >![Top_view](./Image/NMC_Project_Device.jpg)

  IP Location:  
    1. Watershed version:
    2. 8 channels version:

## Introduction

 This project transfers RGB image from 3D Nand flash to target BRAM.  
 The goal is to simultaneously transfer 8* 16k(1 page) into memory by 8-channel.  
 Thus, we design a wrapper(8 channels version) to speed up the AI model (Unet) communication with flash memory.

## Wrapper Command Flow

### 0. Information

Before watching the below Section 1~3, the first need to know is the flow for transfer data :

#### 0.1.Nand Flash Top view

![Top_view](./Image/NMC_Project_Top_view.jpg)

#### 0.2. NMC Flow

3 steps: (1)Trigger, (2)Check, & (3)Transfer

![Flow](./Image/NMC_Project_NMC_Flow.jpg)

### 1. Trigger

In this step, we'll send Trigger command to helper.
Helper will move data from Nand Flash to Nand Flash Controller Buffer.

| Command | Physical address  | Data    |
| :----:  | :----:            | :----:  |
| Opcode  | 0x43Cx_4000       | 32'h1C4 |
| Way     | 0x43Cx_4004       |Flash_Way|
|Row Addr | 0x43Cx_4008       |B*256+P  |
| -       | -                 | -       |
|Command Ready| 0x43Cx_3000   | 32'd1   |

* #### Note

  1. Flash_Way: Unary type (8 bits)
  2. B: Block
  3. P: Page

  * #### NAND Flash Operation Information

    Need to attention that "Nand Flash Controller" receives the "Trigger Command".
    The next(CHECK) command signal cannot transfer to "t4c_hlper_x" because the page data are transmitted
    from "NAND Flash Physical page" to "NAND Flash Controller page buffer".
  > [!TIP]  
  > The "busy signal" in different place has individual name:  
  > Q: This part have some problems about the real Busy signal is for what?  
  > A: Now I think so represent which way is trigger and want to read from.
  > * NAND Flash Controller(v2nfc_x) : port (oReadyBusy[7:0])
  > * Helper (t4nfc_hlper_x) : port (iReadyBusy[7:0])
  > * Unet/Accelerator Wrapper :  
  
### 2. Check

This command will check whether the data is transfered completly or not.

  | Command | Physical address  | Data    |
  | ----    | ----              | ----    |
  | Opcode  | 0x43Cx_4000       | 32'h130 |
  | Way     | 0x43Cx_4004       |Flash_Way|
  | Status Report Address|0x43Cx_4008 | *(1)|
  |Clear Status Report| *(1)     | 32'h0   |
  |-        |-                  |-        |
  |Command Ready| 0x43Cx_3000   | 32'h1   |

### 3. Transfer
  
  | Command | Physical address  | Data    |
  | :----:  | :----:            | :----:  |
  | Opcode  | 0x43Cx_4000       | 32'h338 |
  | Way     | 0x43Cx_4004       |Flash_Way|
  | Row Addr | 0x43Cx_4008       |B*256+P  |
  | -       | -                 | -       |
  | Command Ready| 0x43Cx_3000   | 32'd1   |

#### Report Information

  > [!IMPORTANT]  
  > Q: What is "___Report Address" & "___Report " in the command?  
  > A: Address that you can communicate with firmware & change the place.
  > * Report Address is for NFC to store the information about completly transfered data in the specific place.
  > * Report is the real information about data for checking whether NFC correctly executed.

  >[!NOTE]
  > Read channel need the below 3 Information to read the value.  
  > * #### Note!!
  > The flow before reading the value need a "Clear" step to check the memory put the correct value.
  > #### Status Report (1)
  > You may see different value, like 0x1FFC1 or 0x1C1C1, in  individual channel. However, the value generally in self channel is the same. The below information is explain how to konw the status:  
  > bit 0 -> completion flag of Read Status operation  
  > bit 1 ~ 8 -> result of Read Status operation  
  > bit 9 ~ 16 -> BusyReady value of way 0~7  
  > If you shift right statusReport by 1, you can find the result of Read Status.
  > 0x1FFC1 >> 1 = 0xFFE0
  > ![STATUS_REPORT](./Image/NMC_Project_StatusReport.jpg) 
  > I'm not sure whether now ECC error mode is open.
  > If ECC error mode is open, check flow in firmware like the below step(2)(3): 
  > #### Error Info (2) ###  
  >   Only the upper 4 bytes is ecc ErrorInfoTable,  
  >   and the value threshold is 'd24 
  >   |  Type   | Error Info  |
  >   | :----:  | :----:      |
  >   | Normal  | 0x0000_0000 |
  >   | Error   | 0x1100_0000 |
  >
  > If ECC error mode is close, only check flow in firmware like the below step(3): 
  > #### Completion Report (3) ###
  >   |  Type   | Completion Report |
  >   | :----:  | :----:      |
  >   | Normal  | 0x0000_0001 |
  >   | Error   | 0x1100_0000 |

### Appendix

For now temp. the report ref. Baseaddress
  
| Command | Bseaddress  | Calculate real address|
| ----    | ----        | ----                  |
| (1)     | 0x1700_0100 | + 32  * c +　    w    |
| (2)     | 0x1700_0200 | + 352 * c +　44* w    |
| (3)     | 0x1700_0000 | + 32  * c +　 4* w    |
| -       | -           | -                     |
