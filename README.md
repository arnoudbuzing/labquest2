# labquest2
Wolfram Language paclet to interface with the LabQuest 2 device from Vernier

Download the latest package from here:

https://github.com/arnoudbuzing/labquest2/releases

Install the package (change x.y.z to the appropriate numbers):

    PacletInstall["LabQuest-x.y.z.paclet"]

Start the notebook interface, and load the package:

    Needs["LabQuest2`"]
    
Connect to your LabQuest 2 (change `<ip>` numerical wifi ip address found under 'Connections' from the 'Home' screen):

    labquest2 = InstallLabQuest2["<ip>"]
    
Example:
 
    labquest2 = InstallLabQuest2["192.168.1.68"]
    
This will return a LabQuest2Object expression that you can use to control the device:

    In[1]:= labquest2["Properties"]

    Out[1]= {"Status", "Start", "Stop", "Sets", "Set"}
    
The `Status` property will return information about the current status of the device:

    status = labquest2["Status"]
    
The `Sets` property will return information about all the data collection runs:

    sets = labquest2["Sets"]
    
You can collect the recorded data for a specific set, e.g.:

    data = labquest2[{"Set", "279"}]
    
See the `test.nb` notebook for detailed examples.    
