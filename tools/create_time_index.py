#!/global/apps/python/2.7.3/bin/python
# -*- coding: utf-8 -*-

from netCDF4 import Dataset
import numpy as np
import os
import sys
import re
import datetime

variable_names = {
 #   u'ssrd':'fsw',  # incoming shortwave radiation
 #   u'strd':'flw',    # incoming longwave radiation
    u'cloud':'cldf',
    u'rain':'rain',
    u'Uwind':'uwind',
    u'Vwind':'vwind',
    u'Tair':'tair',
    u'Qair':'humid',
    u'Pair':'rhoa'}


refdate = datetime.datetime(1970, 1, 1, 0, 0)


# text file format.
# date, file_name, index
def write_files(lists):
    for var in lists.keys():
	fname = "{}.txt".format(var)
        time,ff,ind = lists[var]
        sort_index = np.argsort(time) #sorted(range(len(time)), key=lambda k: time[k])
	with open(fname,'w') as f:
            header = "{:7d} lines\n".format(len(sort_index))
            f.write(header)
            for i in sort_index:
		line = "{:5.2f} {:4d} {:20s}\n".format(time[i],ff[i],ind[i])
	        f.write(line)


if __name__ == "__main__":
    print "hello"
    print sys.argv[:]
    try:
    	path = sys.argv[1]
    except:
        print("no path given as argument")
        sys.exit()
    
    lists = {'cldf':(np.empty(0),[],[]),
	# 'flw':(np.empty(0),[],[]),
	 'rain':(np.empty(0),[],[]),
         'uwind':(np.empty(0),[],[]),
         'vwind':(np.empty(0),[],[]),
         'tair':(np.empty(0),[],[]),
         'humid':(np.empty(0),[],[]),
	 'rhoa':(np.empty(0),[],[])}

    sought_nc_vars = set(variable_names.keys())
   
    files = os.listdir(path)
    nc_files = [f for f in files if f[-3:]=='.nc']
    print(nc_files)
    if path[-1] != '/':
       path += '/'
    for f in nc_files:
        print("doing file: {}".format(f))
	nc = Dataset(f)
	all_vars = nc.variables.keys()
        vars = [v for k,v in variable_names.iteritems() if k in all_vars]
	timeslots = nc.variables['time'][:]
        for v in vars:
	    timeslots_,inds,ff = lists[v]
            timeslots_ = np.hstack((timeslots_,timeslots))
            inds = inds + range(1,len(timeslots)+1)
            fs = [path+f]*len(timeslots) # list with repeated elements
            ff = ff+fs
            lists[v] = (timeslots_,inds,ff)
        nc.close()
    print("Writing files")
    write_files(lists)
