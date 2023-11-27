close all;
clc;
clear;

%Check for Support Package Installation
wirelessnetworkSupportPackageCheck;

% random seed
rng(1,"combRecursive")

%
simulationTime = 0.1;
showLiveStateTransitionPlot = true;

%Uses the abstract models of MAC and PHY layers at all the nodes (APs and STAs) by default
MACFrameAbstraction = true;
PHYAbstractionMethod = "tgax-evaluation-methodology";


MACFrameAbstraction = true;
PHYAbstractionMethod = "tgax-evaluation-methodology";


%Residential Scenario Parameters
ScenarioParameters = struct;
ScenarioParameters.BuildingLayout = [3 1 3]; %Specify the number of rooms along the length, breadth, and height of the building.
ScenarioParameters.RoomSize = [10 10 3];% Specify the size of each room in meters.
ScenarioParameters.NumRxPerRoom = 1;%Specify the number of stations per room.

%Configure WLAN Scenario
networkSimulator = wirelessNetworkSimulator.init;

%Nodes Node 1 to Node 12 are APs, and Node 13 to Node 36 are STAs.
[nodeIDs,apPositions,staPositions] = hGetIDsAndPositions(ScenarioParameters);

%WLAN config
accessPointCfg = wlanDeviceConfig(Mode="AP",MCS=2,TransmitPower=10,NoiseFigure=9,BandAndChannel=[2.4,5]);    % AP device configuration
stationCfg = wlanDeviceConfig(Mode="STA",MCS=2,TransmitPower=10,NoiseFigure=9,BandAndChannel=[2.4,5]);       % STA device configuration

%Create two arrays of wlanNode objects, corresponding to the AP nodes and STA nodes, 
%by specifying their Position properties as apPosition and staPosition, respectively.

accessPoints = wlanNode(Position=apPositions, ...
    Name="AP"+(1:size(apPositions,1)), ...
    DeviceConfig=accessPointCfg, ...
    PHYAbstractionMethod=PHYAbstractionMethod, ...
    MACFrameAbstraction=MACFrameAbstraction);
stations = wlanNode(Position=staPositions, ...
    Name="STA"+(1:size(staPositions,1)), ...
    DeviceConfig=stationCfg, ...
    PHYAbstractionMethod=PHYAbstractionMethod, ...
    MACFrameAbstraction=MACFrameAbstraction);


%Create a WLAN network consisting of APs and STAs.
nodes = [accessPoints stations];

%configuration check
hCheckWLANNodesConfiguration(nodes);


%Association and Application Traffic
numAPs = prod(ScenarioParameters.BuildingLayout);                                         % One AP per room
for apID = 1:numAPs
    associateStations(nodes(apID),[nodes(nodeIDs(apID,2:end))],FullBufferTraffic="UL");
end

%Create Network
% help  hCreateSitesFromNodes Create transmitter and receiver sites
% help hTGaxResidentialTriangulation Create the building geometry 
% help  hVisualizeScenario Visualize the residential building along with the transmitter and receiver sites
[txSites,rxSites] = hCreateSitesFromNodes(nodes);
triangulationObj = hTGaxResidentialTriangulation(ScenarioParameters);
hVisualizeScenario(triangulationObj,txSites,rxSites,apPositions)


%Wireless Channel help hTGaxResidentialPathLoss
propModel = hTGaxResidentialPathLoss(Triangulation=triangulationObj,ShadowSigma=0,FacesPerWall=1);
[~,pathLossFcn] = hCreatePathlossTable(txSites,rxSites,propModel);


%add a channel object to the wireless network simulator help hSLSTGaxMultiFrequencySystemChannel
%Add the residential path loss model to the network simulator by using the addChannelModel
channel = hSLSTGaxMultiFrequencySystemChannel(nodes,PathLossModel="custom",PathLossModelFcn=pathLossFcn);
addChannelModel(networkSimulator,channel.ChannelFcn)


%Simulation
addNodes(networkSimulator,nodes)

% view the state transition and performance metrics plots help hSimulationPlotViewer

viewerObj = hSimulationPlotViewer(showLiveStateTransitionPlot,nodes);


% Run the network simulation
run(networkSimulator,simulationTime);



%Results
%Retrieve the APP, MAC, and PHY statistics at each node


stats = statistics(nodes);


% Plot the performance of each node by using the plotNetworkStats help hSimulationPlotViewer


plotNetworkStats(viewerObj,simulationTime)




% Further Exploration : Export WLAN MAC Frames to PCAP or PCAPNG File
%You can capture packets at both AP and STA nodes by using the hExportWLANPackets helper object. 
% Specify the node objects at which you want to capture the packets. 
% To capture packets at multiple nodes, specify the corresponding node objects as an array. 
% You can export the packets captured at the AP and STA nodes to a PCAP or PCAPNG file. 
% For more information about capturing packets, and exporting captured packets to a PCAP or PCAPNG file, 
% see the Get Started with WLAN System-Level Simulation in MATLAB example.



%Appendix
% The example uses these helpers:
% hGetIDsAndPositions — Return node IDs and random positions for the APs and STAs
% hCheckWLANNodesConfiguration — Check if the node parameters are configured correctly
% hCreateSitesFromNodes — Return transmitter and receiver sites
% hTGaxResidentialTriangulation — Create the residential scenario geometry
% hCreatePathlossTable — Return the path loss function handle in the residential scenario
% hVisualizeScenario — Display the residential building along with transmitters and receivers
% hTGaxIndoorLinkInfo — Return the number of floors, the number of walls, and the distance between points for a link
% hExportWLANPackets — Capture MAC frames and write them into a PCAP or PCAPNG file
% hTGaxResidentialPathLoss — Configure and create a residential path loss model
% hSLSTGaxMultiFrequencySystemChannel — Return a system channel object and set the path loss model
% hSLSTGaxAbstractSystemChannel — Return a channel object for an abstracted PHY layer
% hSLSTGaxSystemChannel — Return a channel object for a full PHY layer
% hSLSTGaxSystemChannelBase — Return the base channel object
% hSimulationPlotViewer — Plot the state transition and performance metric figures
% 

