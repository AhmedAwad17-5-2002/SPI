quit -sim
vlib work
vlog RAM2.v TB.v TOP.v SLAVE.v
vsim -voptargs=+acc work.TB
add wave *
run -all