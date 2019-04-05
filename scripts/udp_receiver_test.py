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
    data = sock.recv(8192)
    ch1_i = np.tile(0,len(data)/16)
    ch1_q = np.tile(0,len(data)/16)
    ch2_i = np.tile(0,len(data)/16)
    ch2_q = np.tile(0,len(data)/16)
    if data:
        ind = 0
        for i in range(0,len(data),16):
            ch1_i[ind] = float(ord(data[i   ])+ord(data[i+ 1])+ord(data[i+ 2])+ord(data[i+ 3]))
            #ch1_q = int(ord(data[i+ 4]+data[i+ 5]+data[i+ 6]+data[i+ 7]))
            #ch2_i = int(ord(data[i+ 8]+data[i+ 9]+data[i+10]+data[i+11]))
            #ch2_q = int(ord(data[i+12]+data[i+13]+data[i+14]+data[i+15]))
            ind = ind + 1
        
        #print data[0],; print "    ",; print data[4],; print "    ",; print data[8],; print "    ",; print data[12]
        # ch1_i = data[0::16]
        # ch1_q = data[1::4]
        # ch2_i = data[2::4]
        # ch2_q = data[3::4]
        # print ch1_i
	
        ch1_i_mean = sum(ch1_i)/len(ch1_i)
        #ch1_q_mean = sum(ch1_q)/len(ch1_q)
        #ch2_i_mean = sum(ch2_i)/len(ch2_i)
        #ch2_q_mean = sum(ch2_q)/len(ch2_q)
        print("%9d" % (ch1_i_mean))
        #print("%9d", % (ch1_i_mean)),; print("    "),; print("%9d", % (ch1_q_mean)),; print("    "),; print("%9d", % (ch2_i_mean)),; print("    "),; print("%9d", % (ch2_q_mean))

