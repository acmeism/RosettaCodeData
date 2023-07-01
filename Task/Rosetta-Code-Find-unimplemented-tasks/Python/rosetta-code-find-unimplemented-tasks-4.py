#Aamrun, 3rd February 2023

import xml.dom.minidom
import sys, urllib.parse, urllib.request

def findrc(category):
    name = "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:%s&cmlimit=500&format=xml" % urllib.parse.quote(category)
    cmcontinue, titles = '', []
    while True:
        u = urllib.request.urlopen(name + cmcontinue)
        xmldata = u.read()
        u.close()
        x = xml.dom.minidom.parseString(xmldata)
        titles += [i.getAttribute("title") for i in x.getElementsByTagName("cm")]
        cmcontinue = list(filter( None,
                             (urllib.parse.quote(i.getAttribute("cmcontinue"))
                              for i in x.getElementsByTagName("categorymembers")) ))
        if cmcontinue:
            cmcontinue = '&cmcontinue=' + cmcontinue[0]
        else:
            break
    return titles

alltasks = findrc("Programming_Tasks")
lang = findrc(sys.argv[1])

for i in [i for i in alltasks if i not in lang]:
    print(i)
