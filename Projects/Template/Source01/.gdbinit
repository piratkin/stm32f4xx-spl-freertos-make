define reload
kill
monitor jtag_reset
load
end

target extended localhost:3333
load

thbreak main
continue
