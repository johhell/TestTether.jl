# -*- coding: utf-8 -*-


import sys
import os
import h5py
import sdf
import numpy as np
from subprocess import call


# EXEname = sys.argv[1]
EXEname = "F22"

MAT =  "%s_result.mat"%(EXEname)

if os.path.exists (MAT):
    os.remove (MAT)

cmd = "./%s   -lv LOG_STATS  -r %s >LOG.txt"%(EXEname,MAT)
sts = call(cmd, shell=True)


data = sdf.load(MAT)

#
# conversion MAT to HDF5
#
hf = h5py.File('%s.hdf5'%(EXEname),'w')
hf.create_dataset('zeit', data=data["time"].data)
hf.create_dataset('model', data="modelica")
segments = round(data["segments"].data)
hf.create_dataset('segments', data=segments)

g1 = hf.create_group('positions')

for i in range(segments):
    ps = "pos%d" % (i+1)
    ele = "element%d" % (i+1)
    rx=data[ele]["body1"]["r_0[1]"].data
    ry=data[ele]["body1"]["r_0[2]"].data
    rz=data[ele]["body1"]["r_0[3]"].data

    pxyz = np.array([rx,ry,rz])

    g1.create_dataset(ps, data=pxyz)

hf.close()

