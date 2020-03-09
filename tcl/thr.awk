BEGIN {
	recv = 0
	currTime = prevTime = 0
	tic = 0.1
	through = throughput = 0
}

{
	# Trace line 
	if ($2 != "-t") {
		event = $1
		time = $2
		if (event == "+" || event == "-") node_id = $3
		if (event == "r" || event == "d") node_id = $4
		flow_id = $6
		pkt_id = $12
		pkt_size = $8
		flow_t = $5
		level = "AGT"
	}
	# Trace line 
	if ($2 == "-t") {
		event = $1
		time = $3
		node_id = $5
		flow_id = $39
		pkt_id = $41
		pkt_size = $37
		flow_t = $45
		level = $19
	}

	# Init prevTime 
	if(prevTime == 0) prevTime = time;
		
		# 
	# Calculate total received packets' size
	if ($4 == "MAC" &&  event == "r" && $7 == "tcp") {
		# Store received packet's size
		recv += pkt_size
		
		# 
		currTime += (time - prevTime)
		if (currTime >= tic) {
			through = (recv/currTime)*(8/1000)
			printf("%15g %18g\n",time,through)
			throughput = through+throughput
			recv = 0
			currTime = 0
		}
		prevTime = time
	}

}

END {
	print "Received: ", throughput, "Kbps";
	printf("\n\n")
}
