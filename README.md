# TIMER IP VIA APB PROTOCOL
- Timer is an essential module for every chip.
- This is used to generate accurate timing interval or controlling the timing of various operations within the circuit. Timer can be used in various application: pulse generation, delay generation, event generation, PWM generation, Interrupt generation ….
- In this project, a timer module is customized from CLINT module of industrial RISC-V architecture. It is used to generate interrupt based on user settings.
- The spec of CLINT can be referred at: https://chromitem-soc.readthedocs.io/en/latest/clint.html
- The timer has following features:
+ 64-bit count-up
+ 12-bit address
+ Register set is configured via APB bus (IP is APB slave)
+ Support wait state (1 cycle is enough) and error handling
+ Support byte access
+ Support halt (stop) in debug mode
+ Timer uses active low async reset
+ Counter can be counted based on the system clock or divided up to 256
+ Support timer interrupt (can be enabled or disabled)
+ Coverage achieved is 100%
<img width="701" height="413" alt="image" src="https://github.com/user-attachments/assets/76f7b037-0f0e-487d-b3d0-b6461fbfc989" />
- Register Summary
  <img width="786" height="383" alt="image" src="https://github.com/user-attachments/assets/3ac6b59d-a0e9-4894-8957-97044677f1f6" />
  
* If you want to know more information and detailed content, you can refer to the "Timer_Design_Specification"
- Coverage
<img width="528" height="732" alt="image" src="https://github.com/user-attachments/assets/a36d7e8f-112b-4ad5-9167-bf24bc260378" />
