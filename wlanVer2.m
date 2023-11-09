scenario = struct;
scenario.BuildingLayout = [2 1 3];%[rooms_x rooms_y floors]
scenario.RoomSize = [10 10 3]; % in meters
% Number of WLAN nodes
numNodes = 6;

% Define the positions for the WLAN nodes
nodePositions = [5 5 3; 15 5 3; 5 5 6; 15 5 6; 5 5 9; 15 5 9];

% Create an array to store the WLAN nodes
wlanNodes = wlanNode.empty(0, numNodes);
%deviceCfg = wlanDeviceConfig(Mode="mesh",NoiseFigure=9);

deviceCfg = wlanDeviceConfig(Mode="mesh",NoiseFigure=9);

% Create and configure the WLAN nodes using wlanNode and wlanDeviceConfig
for i = 1:numNodes
    % Create a wlanNode object
    wlanNodeObj = wlanNode;
    % Set the node position and name directly in the wlanNode object
    wlanNodeObj.Position = nodePositions(i, :);
    wlanNodeObj.Name = ['Node ' num2str(i)];
    wlanNodes(i) = wlanNode(DeviceConfig=deviceCfg,Position=nodePositions(i,:),Name=['Node ' num2str(i)]);
end




%buildingTriangulation = hTGaxResidentialTriangulation(scenario);
% Display the building triangulation with WLAN nodes
% helperVisualizeResidentialScenario(buildingTriangulation, ...
%                                   {wlanNodes}, ... % Include the WLAN nodes
%                                   "WLAN Node", ...
%                                   "Residential Scenario with WLAN Nodes");

% Display the building layout
figure;
hold on;

% Create the building layout based on the scenario
buildingLayout = scenario.BuildingLayout;
roomSize = scenario.RoomSize;

for floor = 1:buildingLayout(3)
    for row = 1:buildingLayout(2)
        for col = 1:buildingLayout(1)
            x = (col - 1) * roomSize(1);
            y = (row - 1) * roomSize(2);
            z = (floor - 1) * roomSize(3);

            % Define the vertices of the room as a cuboid
            roomVertices = [
                x, y, z;
                x, y + roomSize(2), z;
                x + roomSize(1), y + roomSize(2), z;
                x + roomSize(1), y, z;
                x, y, z + roomSize(3);
                x, y + roomSize(2), z + roomSize(3);
                x + roomSize(1), y + roomSize(2), z + roomSize(3);
                x + roomSize(1), y, z + roomSize(3);
            ];

            % Define the faces of the cuboid
            roomFaces = [
                1, 2, 3, 4;
                5, 6, 7, 8;
                1, 2, 6, 5;
                2, 3, 7, 6;
                3, 4, 8, 7;
                4, 1, 5, 8;
            ];

            % Plot room boundaries
            patch('Faces', roomFaces, 'Vertices', roomVertices, 'FaceColor', 'none', 'EdgeColor', 'b');
        end
    end
end

% Plot WLAN nodes
scatter3(nodePositions(:, 1), nodePositions(:, 2), nodePositions(:, 3), 100, 'filled');
labels = {wlanNodes.Name};
text(nodePositions(:, 1), nodePositions(:, 2), nodePositions(:, 3), labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

hold off;

title('Building Layout with WLAN Nodes');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
grid on;
view(3);

%pm = propagationModel('freespace');
% txSite = site(wlanNodes(1).Position);
% rxSite = site(wlanNodes(2).Position);
%txSite = txsite('Name', 'Transmitter1', ...
%                'AntennaPosition', wlanNodes(1).Position');
%rxSite = rxsite('Name', 'Transmitter2', ...
%                'AntennaPosition', wlanNodes(1).Position');

% Calculate path loss
%pl = pathloss(pm, rxSite, txSite);

% Propagation model
fc = 2.4;
d = zeros(numNodes, numNodes);
PL = zeros(numNodes, numNodes);
floors = zeros(numNodes, 1);
walls = zeros(numNodes, 1);
for i = 1:numNodes
    floors(i) = ceil(i / 2);
    walls(i) = abs(rem(i, 2));
end

for i = 1:numNodes
    for j = 1:numNodes
        d(i, j) = norm(nodePositions(i, :) - nodePositions(j, :));
        n_floor = abs(floors(i) - floors(j));
        n_wall = abs(walls(i) - walls(j));
        PL(i, j) = 40.05 + 20 * log10(fc / 2.4) + 20 * log10(min(d(i, j), 5)) ...
            + 18.3 * n_floor^((n_floor + 2) / (n_floor + 1) - 0.46) + 5 * n_wall; 
        if d(i, j) > 5
            PL(i, j) = PL(i, j) + 35 * log10(d(i, j) / 5);
        end
        if i == j
            PL(i, j) = 0;
        end
    end
end


% % Calculate the distance between sourceNode and destNode
% distance = norm(nodePositions(sourceNodeIdx, :) - nodePositions(destNodeIdx, :));
% 
% % Define path loss models for walls and floors
% pathLossModelWalls = @(d) (wall_loss_formula_here);
% pathLossModelFloors = @(d) (floor_loss_formula_here);
% 
% % Check if the signal path includes walls or floors
% if signalPassesThroughWalls
%     pathLoss = pathLossModelWalls(distance);
% else
%     pathLoss = pathLossModelFloors(distance);
% end
% 
% % Now you have the path loss value for the chosen path (walls or floors)