#!/usr/bin/env python3


import os


for root, dirs, files in os.walk('.'):
    for f in files:
        print('Process {}? (y/n) '.format(f))
        response = str(input())
        if response == 'y' or response == 'Y':
            fullpath = os.path.join(root, f)
            filename = f.split('.')
            with open(fullpath, 'r') as fin:
                bin_out = open(os.path.join(root, filename[0] + "_bin." + filename[1]), 'w')
                data_out = open(os.path.join(root, filename[0] + "_data." + filename[1]), 'w')
                data_flag = False
                for line in fin:
                    if not data_flag:
                        data_flag = 'Data Segment' in line
                    if not data_flag:
                        bin_out.write(line)
                    else:
                        data_out.write(line)
                for i in range(5):
                    bin_out.write('1111111_11111_11111_11111_1111111111  //         HALT\n')

