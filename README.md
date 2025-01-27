# Verilog-Project-NMC
Verilog-Project-NMC for NCKU CAID Lab

# Environment
  Vivado: 2019.1  
  IP Location:  
    1. Watershed version:   
    2. 8 channels version 

# Wrapper Command Flow #
  3 steps: Trigger, Check, & Transfer
  
  Way : 8 bits

  ## 1. Trigger ##

  | Command | Physical address  | Data    |
  | :----:  | :----:            | :----:  |
  | Opcode  | 0x43Cx_4000       | 32'h1C4 |
  | Way     | 0x43Cx_4004       |Flash_Way|
  |Row Addr | 0x43Cx_4008       |B*256+P  |
  | -       | -                 | -       |
  |Ready    | 0x43Cx_3000       | 32'd1   |

  * ### Note: ### 
    
  1. Flash_Way: Unary type
  2. B: Block
  3. P: Page
  
  ## 2. Check ##
    opcode: 0x130

  | Command | Physical address  | Data    |
  | ----    | ----              | ----    |
  | Opcode  | 0x43Cx_4000       | 0x130   |
  | Way     | 0x43Cx_4004       |Flash_Way|

  Need to Command Ready
  3. Transfer
    opcode: 0x338

  Need to Command Ready
  

