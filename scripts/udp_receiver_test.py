import sys
import socket
import struct
import numpy as np
from decimal import *

UDP_IP = "0.0.0.0"
UDP_PORT = 5001

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

sock.bind((UDP_IP, UDP_PORT))

while True:
    data_str = sock.recv(2048)
    data = np.tile(0,len(data_str))
    for i in range(len(data_str)):
        data[i] = int(ord(data_str[i]))
    if data_str:
        #print data[0],; print "    ",; print data[4],; print "    ",; print data[8],; print "    ",; print data[12]
        ch1_i = data[0::16]
        ch1_q = data[1::4]
        ch2_i = data[2::4]
        ch2_q = data[3::4]
        print ch1_i
	
        ch1_i_mean = sum(ch1_i)/len(ch1_i)
        ch1_q_mean = sum(ch1_q)/len(ch1_q)
        ch2_i_mean = sum(ch2_i)/len(ch2_i)
        ch2_q_mean = sum(ch2_q)/len(ch2_q)
        #print(ch1_i_mean),; print "    ",; print(ch1_q_mean),; print "    ",; print(ch2_i_mean),; print "    ",; print(ch2_q_mean)

