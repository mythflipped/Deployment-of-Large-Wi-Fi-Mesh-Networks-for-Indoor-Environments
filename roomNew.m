% Total building dimensions
buildingLength = 30;  % in meters
buildingWidth = 10;   % in meters
buildingHeight = 9;   % in meters

% Number of floors
numFloors = 3;

% Height of each floor
floorHeight = buildingHeight / numFloors;

% Number of rooms on each floor
roomsPerFloor = [4, 3, 5];  % Total 12 rooms

% Create a 3D figure for visualization
figure;

% Room specifications for each floor
roomSpecs = [
    % First floor
    0, 10, 0, 5, 0, 3;     % Room 1
    0, 10, 5, 10, 0, 3;    % Room 2
    10, 20, 0, 10, 0, 3;   % Room 3
    20, 30, 0, 10, 0, 3;   % Room 4
    
    % Second floor
    0, 10, 0, 10, 3, 6;    % Room 5
    10, 20, 0, 10, 3, 6;   % Room 6
    20, 30, 0, 10, 3, 6;   % Room 7
    
    % Third floor
    0, 10, 0, 5, 6, 9;     % Room 8
    0, 10, 5, 10, 6, 9;    % Room 9
    10, 20, 0, 5, 6, 9;    % Room 10
    10, 20, 5, 10, 6, 9;   % Room 11
    20, 30, 0, 10, 6, 9;   % Room 12
];

% Plot each room on each floor
startIndex = 1;
for floor = 1:numFloors
    for room = 1:roomsPerFloor(floor)
        xStart = roomSpecs(startIndex, 1);
        xEnd = roomSpecs(startIndex, 2);
        yStart = roomSpecs(startIndex, 3);
        yEnd = roomSpecs(startIndex, 4);
        zStart = roomSpecs(startIndex, 5);
        zEnd = roomSpecs(startIndex, 6);
        
        % Draw 3D box using rectangles in 3D space
        plot3([xStart, xEnd, xEnd, xStart, xStart], [yStart, yStart, yEnd, yEnd, yStart], [zStart, zStart, zStart, zStart, zStart], 'b-', 'LineWidth', 1);
        hold on;
        plot3([xStart, xEnd, xEnd, xStart, xStart], [yStart, yStart, yEnd, yEnd, yStart], [zEnd, zEnd, zEnd, zEnd, zEnd], 'b-', 'LineWidth', 1);
        plot3([xStart, xEnd, xEnd, xStart, xStart], [yStart, yStart, yStart, yStart, yStart], [zStart, zStart, zEnd, zEnd, zStart], 'b-', 'LineWidth', 1);
        plot3([xStart, xEnd, xEnd, xStart, xStart], [yEnd, yEnd, yEnd, yEnd, yEnd], [zStart, zStart, zEnd, zEnd, zStart], 'b-', 'LineWidth', 1);
        
        startIndex = startIndex + 1;
    end
end

% Set axis labels and title
xlabel('X-axis (m)');
ylabel('Y-axis (m)');
zlabel('Z-axis (m)');
title('3D Building Layout');
grid on;

% Number of WLAN nodes
numNodes = 13; % 12 routers + 1 server
nodePositions = [
    5 2.5 3; 
    5 7.5 3; 
    15 5 3;
    25 5 3; %First floor
    5 5 6; 
    15 5 6; 
    25 5 6; %Second floor
    5 2.5 9;
    5 7.5 9;
    15 2.5 9; 
    15 7.5 9;
    25 5 9;
    15 5 11
    ];

% Create an array to store the WLAN nodes
wlanNodes = wlanNode.empty(0, numNodes);
deviceCfg = wlanDeviceConfig(Mode = "mesh",NoiseFigure = 9);
for i = 1:numNodes-1
    % Create a wlanNode object
    wlanNodeObj = wlanNode;
    % Set the node position and name directly in the wlanNode object
    wlanNodeObj.Position = nodePositions(i, :);
    wlanNodeObj.Name = ['Node ' num2str(i)];
    wlanNodes(i) = wlanNode(DeviceConfig = deviceCfg,Position = nodePositions(i, :),Name = ['Router' num2str(i)]);
end

deviceCfg2 = wlanDeviceConfig(Mode = "STA",NoiseFigure = 9);
wlanNodes(numNodes) = wlanNode(DeviceConfig = deviceCfg2,Name = ['Server']);

scatter3(nodePositions(:, 1), nodePositions(:, 2), nodePositions(:, 3), 100, 'filled');
labels = {wlanNodes.Name};
text(nodePositions(:, 1), nodePositions(:, 2), nodePositions(:, 3), labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');



% %Add WLAN nodes
% wlanNodes = [
%     5, 5, 1;   % x, y, z coordinates of WLAN node 1 on the first floor
%     15, 5, 4;  % x, y, z coordinates of WLAN node 2 on the second floor
%     25, 5, 7;  % x, y, z coordinates of WLAN node 3 on the third floor
% ];
% 
% scatter3(wlanNodes(:, 1), wlanNodes(:, 2), wlanNodes(:, 3), 'r', 'filled', 'Marker', 'o');