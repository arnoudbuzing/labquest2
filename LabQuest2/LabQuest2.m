BeginPackage["LabQuest2`"]

InstallLabQuest2::usage = "InstallLabQuest2[ip] installs the LabQuest2 at ip address `ip` for use with the Wolfram Language"
LabQuest2Object::usage = "LabQuest2Object is a symbolic representation of the device in the Wolfram Language"

Begin["`Private`"]

labquest2dir = DirectoryName[ $InputFileName ]

labquest2icon = Import[ FileNameJoin[{ labquest2dir, "labquest2.jpg"}] ]

MakeBoxes[ LabQuest2Object[ assoc_Association ], fmt_ ] := BoxForm`ArrangeSummaryBox[
 "LabQuest2Object", LabQuest2Object, labquest2icon,
 { BoxForm`SummaryItem[{ "ip: ", assoc["ip"] }] }, { },
 fmt
]

InstallLabQuest2[ip_String] := Module[ {}, LabQuest2Object[ <| "ip" -> ip, "url" -> "http://"<>ip |> ] ] 

LabQuest2Object[ assoc_Association ]["Properties"] := { "Status", "Start", "Stop", "Sets", "Set", "Views", "Columns", "Plot" }

LabQuest2Object[ assoc_Association ]["Status"] := Dataset @ Import[ assoc["url"] <> "/status", "RawJSON"] 
LabQuest2Object[ assoc_Association ]["Sets"] := LabQuest2Object[assoc]["Status"]["sets"] 
LabQuest2Object[ assoc_Association ]["Views"] := LabQuest2Object[assoc]["Status"]["views"] 
LabQuest2Object[ assoc_Association ]["Columns"] := LabQuest2Object[assoc]["Status"]["columns"] 

LabQuest2Object[ assoc_Association ]["Start"] := URLExecute[ assoc["url"] <> "/control/start"]
LabQuest2Object[ assoc_Association ]["Stop"] := URLExecute[ assoc["url"] <> "/control/stop"]

LabQuest2Object[ assoc_Association ][{"Set",n_String}] := Module[ { obj, columns, meta },
 obj = LabQuest2Object[assoc];
 columns = Normal @ obj["Sets"][n,"colIDs"];
 meta = obj["Columns"][Select[MemberQ[columns,#id]&]]; 
 Dataset @ Map[ <| "name" -> meta[#,"name"], "unit"->meta[#,"units"], "data" -> Import[assoc["url"] <> "/columns/" <> #, "RawJSON"]["values"] |> &, columns ]
]

LabQuest2Object[ assoc_Association ][{"Plot",n_String}] := Module[ { obj, data },
 obj = LabQuest2Object[assoc];
 data = obj[{"Set",n}];
 ListLinePlot[ Transpose[ Normal[ data[All, "data" ] ] ], PlotStyle -> Red, Frame -> True, FrameLabel -> Normal @ data[All,"name"] ]
]

End[]

EndPackage[]

