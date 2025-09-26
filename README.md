# TIMER IP VIA APB PROTOCOL
- 64-bit count-up
- 12-bit address
- Register set is configured via APB bus (IP is APB slave)
- Support wait state (1 cycle is enough) and error handling
- Support byte access
- Support halt (stop) in debug mode
- Timer uses active low async reset
- Counter can be counted based on the system clock or divided up to 256
- Support timer interrupt (can be enabled or disabled)
