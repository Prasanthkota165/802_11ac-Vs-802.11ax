# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             6                          ;# number of mobilenodes
set val(rp)             DumbAgent                      ;# RPL
set val(x)             2000                    ;# X dimension of topography
set val(y)             2000                     ;# Y dimension of topography
Phy/WirelessPhy set bandwidth 69	
Mac/802_11 set SlotTime_          0.000050;         # 50us
Mac/802_11 set SIFS_              0.000028;         # 28us
Mac/802_11 set PreambleLength_    0;                # no preamble
Mac/802_11 set PLCPHeaderLength_  128;              # 128 bits
Mac/802_11 set PLCPDataRate_      1.0e6;            # 1Mbps
Mac/802_11 set dataRate_          11.0e6;           # 11Mbps
Mac/802_11 set basicRate_         1.0e6;            # 1Mbps
#==================================
#        Initialization        
#===================================
#Create a ns simulator
set ns_ [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)OLSR	
#create-god $val(nn)
#
# Create God
#
set god_ [create-god $val(nn)]

#Open the NS trace file
set tracefile [open WIFI.tr w]
$ns_ trace-all $tracefile

#Open the NAM trace file
set namfile [open WIFI.nam w]
$ns_ namtrace-all $namfile
$ns_ namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

# ==============================
# configure node

        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON			
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
	}

#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
$node_(0) set X_ 1270.0
$node_(0) set Y_ 1369.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 120.0
$node_(1) set Y_ 639.0
$node_(1) set Z_ 0.0



$node_(2) set X_ 400.0
$node_(2) set Y_ 399.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 1309.0
$node_(3) set Y_ 769.0
$node_(3) set Z_ 0.0


$node_(4) set X_ 1129.0
$node_(4) set Y_ 169.0
$node_(4) set Z_ 0.0
 
$node_(5) set X_ 1846.0
$node_(5) set Y_ 989.0
$node_(5) set Z_ 0.0




## Setting The Node Size
                              
      $ns_ initial_node_pos $node_(0) 120
      $ns_ initial_node_pos $node_(1) 120
      $ns_ initial_node_pos $node_(2) 80
      $ns_ initial_node_pos $node_(3) 80
      $ns_ initial_node_pos $node_(4) 80
      $ns_ initial_node_pos $node_(5) 80


 #### Setting The Labels For Nodes
      
     
      $ns_ at 0.0 "$node_(1) label AP"
      $ns_ at 0.0 "$node_(2) label USER"
      $ns_ at 0.0 "$node_(3) label USER"
      $ns_ at 0.0 "$node_(4) label USER"
      $ns_ at 0.0 "$node_(5) label USER"
      $ns_ at 0.0 "$node_(0) label AP"


   




#
set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(1) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(2) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 512
$cbr_(0) set interval_ 0.025000000000000001
$cbr_(0) set random_ 1
$cbr_(0) set maxpkts_ 10000
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
$ns_ at 10.148995671490674 "$cbr_(0) start"
#
# 1 connecting to 3 at time 21.373835830657669
#
set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $node_(4) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 512
$cbr_(1) set interval_ 0.025000000000000001
$cbr_(1) set random_ 1
$cbr_(1) set maxpkts_ 10000
$cbr_(1) attach-agent $udp_(1)
$ns_ connect $udp_(1) $null_(1)
$ns_ at 10.373835830657669 "$cbr_(1) start"
#
# 4 connecting to 5 at time 85.087624837219536
#
set udp_(2) [new Agent/UDP]
$ns_ attach-agent $node_(4) $udp_(2)
set null_(2) [new Agent/Null]
$ns_ attach-agent $node_(5) $null_(2)
set cbr_(2) [new Application/Traffic/CBR]
$cbr_(2) set packetSize_ 512
$cbr_(2) set interval_ 0.025000000000000001
$cbr_(2) set random_ 1
$cbr_(2) set maxpkts_ 10000
$cbr_(2) attach-agent $udp_(2)
$ns_ connect $udp_(2) $null_(2)
$ns_ at 10.087624837219536 "$cbr_(2) start"
#
# 4 connecting to 6 at time 107.98604084550684
#
set udp_(3) [new Agent/UDP]
$ns_ attach-agent $node_(3) $udp_(3)
set null_(3) [new Agent/Null]
$ns_ attach-agent $node_(2) $null_(3)
set cbr_(3) [new Application/Traffic/CBR]
$cbr_(3) set packetSize_ 512
$cbr_(3) set interval_ 0.025000000000000001
$cbr_(3) set random_ 1
$cbr_(3) set maxpkts_ 10000
$cbr_(3) attach-agent $udp_(3)
$ns_ connect $udp_(3) $null_(3)
$ns_ at 10.98604084550684 "$cbr_(3) start"
#
# 5 connecting to 6 at time 14.151656634244908
#
set udp_(4) [new Agent/UDP]
$ns_ attach-agent $node_(5) $udp_(4)
set null_(4) [new Agent/Null]
$ns_ attach-agent $node_(1) $null_(4)
set cbr_(4) [new Application/Traffic/CBR]
$cbr_(4) set packetSize_ 512
$cbr_(4) set interval_ 0.025000000000000001
$cbr_(4) set random_ 1
$cbr_(4) set maxpkts_ 10000
$cbr_(4) attach-agent $udp_(4)
$ns_ connect $udp_(4) $null_(4)
$ns_ at 10.151656634244908 "$cbr_(4) start"
#
# 5 connecting to 0 at time 58.178792036221729
#
set udp_(5) [new Agent/UDP]
$ns_ attach-agent $node_(2) $udp_(5)
set null_(5) [new Agent/Null]
$ns_ attach-agent $node_(0) $null_(5)
set cbr_(5) [new Application/Traffic/CBR]
$cbr_(5) set packetSize_ 512
$cbr_(5) set interval_ 0.025000000000000001
$cbr_(5) set random_ 1
$cbr_(5) set maxpkts_ 10000
$cbr_(5) attach-agent $udp_(5)
$ns_ connect $udp_(5) $null_(5)
$ns_ at 10.178792036221729 "$cbr_(5) start"
#





#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 600.0 "DONE"
$ns_ at 2100.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ trace
    $ns_ flush-trace
    close $trace
}

puts "Starting Simulation..."
$ns_ run

