BeginPackage["LabQuest2`"]

InstallLabQuest2::usage = "InstallLabQuest2[ip] installs the LabQuest2 at ip address `ip` for use with the Wolfram Language"
LabQuest2Object::usage = "LabQuest2Object is a symbolic representation of the device in the Wolfram Language"
LabQuest2::usage = "LabQuest2[] runs an experiment on your device and returns the result"

Begin["`Private`"]

labquest2dir = DirectoryName[ $InputFileName ]

labquest2icon = Import[ FileNameJoin[{ labquest2dir, "labquest2.jpg"}] ]

MakeBoxes[ LabQuest2Object[ assoc_Association ], fmt_ ] := BoxForm`ArrangeSummaryBox[
 "LabQuest2Object",
 LabQuest2Object,
 labquest2icon,
 { BoxForm`SummaryItem[{ "ip: ", assoc["ip"] }] },
 { },
 fmt
]


InstallLabQuest2[ip_String] := Module[ {}, LabQuest2Object[ <| "ip" -> ip, "url" -> "http://"<>ip |> ] ] 

LabQuest2Object[ assoc_Association ]["Properties"] := { "Status", "Start", "Stop", "Sets", "Set" }

LabQuest2Object[ assoc_Association ]["Status"] := Module[{ status },
 status = Import[ assoc["url"] <> "/status", "RawJSON"];
 Dataset[status]
]

LabQuest2Object[ assoc_Association ]["Start"] := Module[ { },
 URLExecute[ assoc["url"] <> "/control/start"];
]

LabQuest2Object[ assoc_Association ]["Stop"] := Module[ {},
 URLExecute[ assoc["url"] <> "/control/stop"];
]

LabQuest2Object[ assoc_Association ]["Sets"] := Module[ { status },
 status = Import[ assoc["url"] <> "/status", "RawJSON"];
 Dataset[ status["sets"] ]
]

LabQuest2Object[ assoc_Association ][{"Set",n_String}] := Module[ { columns },
 status = Dataset @ Import[ assoc["url"] <> "/status", "RawJSON"];
 columns = Normal @ LabQuest2Object[assoc]["Sets"][n,"colIDs"];
 meta = status["columns"][Select[MemberQ[columns,#id]&]]; 
 Dataset @ Map[ <| "name" -> meta[#,"name"], "unit"->meta[#,"units"], "data" -> Import[assoc["url"] <> "/columns/" <> #, "RawJSON"]["values"] |> &, columns ]
]


End[]

EndPackage[]

