import subprocess
import os
import csv
import sys

def main(argv):
    if len(argv) == 1:
        flname = 'sample.csv'
    else:
        if os.path.isfile(argv[1]):
            flname = argv[1]

    command = 'C:\\Program Files\\OpenSCAD\\openscad.com'

    cwd = os.getcwd()
    scadfl = os.path.join(cwd, 'HeadsTails.scad')
    # print('Command = %s' % command)

    aimages = []
    bimages = []
    notfound = []

    tempstlfol = os.path.join(cwd, 'outstls')

    try:
        os.stat(tempstlfol)
    except:
        os.mkdir(tempstlfol)

    # debugging options
    makefaces = True;
    makecoins = True;

    with open(flname, 'rb') as csvfile:
        csvreader = csv.reader(csvfile)

        # read the entire file in... note, we assume you are being 'reasonable' with your file length
        csvall = list(csvreader)

        # Go through the file once and process all the faces.
        for row in csvall:
            if len(row) == 3:
                afl = row[1].strip()
                bfl = row[2].strip()
                if afl not in aimages and len(afl) > 0:
                    if os.path.isfile(afl):
                        aimages.append(afl)
                        stlname = os.path.splitext(afl)[0] + '-head.stl'
                        print("Creating Face: %s -> %s" % (afl, stlname))
                        outstlname = os.path.join(tempstlfol, stlname)
                        params = '-o "%s" -D part=\\"face\\" -D flip=false -D flface=\\"%s\\" "%s"' % \
                                 (outstlname, afl, scadfl)
                        cmdline = command + ' ' + params
                        print '    ' + cmdline
                        if makefaces:
                            subprocess.call(cmdline)
                    else:
                        # error state
                        print("Cannot find texture: %s" % afl)
                        notfound.append(afl)
                if bfl not in bimages and len(bfl) > 0:
                    if os.path.isfile(bfl):
                        bimages.append(bfl)
                        stlname = os.path.splitext(bfl)[0] + '-tail.stl'
                        print("Creating Face: %s -> %s" % (bfl, stlname))
                        outstlname = os.path.join(tempstlfol, stlname)
                        params = '-o "%s" -D part=\\"face\\" -D flip=true -D flface=\\"%s\\" "%s"' % \
                                 (outstlname, bfl, scadfl)
                        cmdline = command + ' ' + params
                        print '    ' + cmdline
                        if makefaces:
                            subprocess.call(cmdline)
                    else:
                        # error state
                        print("Cannot find texture: %s" % bfl)
                        notfound.append(bfl)
            else:
                # row did not have three entries
                print ('Invalidly formed row: `%s`: Did not have exactly three items' % row)

        # Then go through again and this time make coins
        for row in csvall:
            if len(row) == 3:
                stlname = row[0].strip()
                if stlname[:-4] != '.stl':
                    stlname = stlname + '.stl'
                afl = row[1].strip()
                bfl = row[2].strip()
                astlname = os.path.join(tempstlfol, os.path.splitext(afl)[0] + '-head.stl')
                bstlname = os.path.join(tempstlfol, os.path.splitext(bfl)[0] + '-tail.stl')
                astlname = '/'.join(astlname.split('\\'))  # crude windows hack to get around bad command line parsing
                bstlname = '/'.join(bstlname.split('\\'))  # of absolute directories
                if afl in aimages and bfl in bimages:
                    outstlname = os.path.join(cwd, stlname)
                    # once for coin
                    params = '-o "%s" -D part=\\"coin\\" -D "afl=\\"%s\\"" -D "bfl=\\"%s\\"" "%s"' % \
                             (outstlname, astlname, bstlname, scadfl)
                    cmdline = command + ' ' + params
                    print('Making Coin %s from %s and %s' % (stlname, afl, bfl))
                    print '    ' + cmdline
                    if makecoins:
                        subprocess.call(cmdline)
                    # and then for coin in base
                    outstlname = os.path.join(cwd, 'based-' + stlname)
                    params = '-o "%s" -D part=\\"both\\" -D "afl=\\"%s\\"" -D "bfl=\\"%s\\"" "%s"' % \
                             (outstlname, astlname, bstlname, scadfl)
                    cmdline = command + ' ' + params
                    print('Making Coin in Base %s from %s and %s' % (stlname, afl, bfl))
                    print '    ' + cmdline
                    if makecoins:
                        subprocess.call(cmdline)
                else:
                    print("Cannot form coin: %s, %s; %s is missing" % (afl, bfl, afl if afl in notfound else bfl))

    print('All Done!')

main(sys.argv)
