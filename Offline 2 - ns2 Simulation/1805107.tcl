# if{$argc != 3}{
#     puts "NEED THREE ARGUMENTS"
# }
# else
# {
set ns [new Simulator]

# ======================================================================
# Define options
# set topoSize 500
set topoSize [lindex $argv 0]
puts $topoSize

set val(nn) 40
set val(nn) [lindex $argv 1]               ;# number of mobilenodes

set val(nf) 20
set val(nf) [lindex $argv 2]                ;# number of flows

set file [open data.csv "a"]
puts -nonewline $file "$topoSize,$val(nn),$val(nf),"

set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           DSDV                     ;# ad-hoc routing protocol 
# =======================================================================

set trace_file [open trace.tr w]
$ns trace-all $trace_file

set nam_file [open animation.nam w]
$ns namtrace-all-wireless $nam_file $topoSize $topoSize

set topo [new Topography]
$topo load_flatgrid $topoSize $topoSize 

set rng [new RNG]
$rng seed 7


create-god $val(nn)

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -channelType $val(chan) \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

# create nodes
for {set i 0} {$i < $val(nn) } {incr i} {
    set node($i) [$ns node]
    $node($i) random-motion 0       ;# disable random motion

    $node($i) set X_ [ $rng uniform 0.0 $topoSize ]
    $node($i) set Y_ [ $rng uniform 0.0 $topoSize ]
    $node($i) set Z_ 0

    $ns initial_node_pos $node($i) 20
    $ns at 0.0 "$node($i) setdest [$rng uniform 0.0 $topoSize] [$rng uniform 0.0 $topoSize] [$rng uniform 1 5]"
} 


set dest [expr int(floor([$rng uniform 0 $val(nn)]))]

for {set i 0} {$i < $val(nf)} {incr i} {
    set src $dest
    while {$src == $dest} {
        set src [expr int(floor([$rng uniform 0 $val(nn)]))]
    }
    # puts "source ($src) $dest"


    set udp [new Agent/UDP]
    $ns attach-agent $node($src) $udp

    set null [new Agent/UDP]
    $ns attach-agent $node($dest) $null 

    $ns connect $udp $null
    $udp set fid_ $i

    set e [new Application/Traffic/Exponential]
    $e attach-agent $udp

    # $e set packetSize_ 150
    # $e set burst_time_ 500ms
    # $e set idle_time_ 500ms
    # $e set rate_ 100k
    
    $ns at 0.0 "$e start"
    $ns at 50.0 "$e stop"
}



# End Simulation

# Stop nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 50.0 "$node($i) reset"
}

# call final function
proc finish {} {
    global ns trace_file nam_file
    $ns flush-trace
    close $trace_file
    close $nam_file
}

proc halt_simulation {} {
    global ns
    # puts "Simulation ending"
    $ns halt
}

$ns at 50.0001 "finish"
$ns at 50.0002 "halt_simulation"



# Run simulation
# puts "Simulation starting"
$ns run

# area,nodes,flows,throughput,delay,delievery_ratio,drop_ratio
# }