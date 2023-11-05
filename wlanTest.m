scenario = struct;
scenario.BuildingLayout = [2 1 3];%[rooms_x rooms_y floors]
scenario.RoomSize = [5 5 3]; % in meters
% Number of WLAN nodes
numNodes = 6;

% Define the positions for the WLAN nodes
nodePositions = [2.5 2.5 1.5; 7.5 2.5 1.5; 2.5 2.5 4.5; 7.5 2.5 4.5; 2.5 2.5 7.5; 7.5 2.5 7.5];

% Create an array to store the WLAN nodes
wlanNodes = wlanNode.empty(0, numNodes);

% Create and configure the WLAN nodes
for i = 1:numNodes
    wlanNodeObj = wlanNode;
    wlanNodeObj.Position = nodePositions(i, :);
    wlanNodeObj.Name = ['Node ' num2str(i)];
    wlanNodes(i) = wlanNodeObj;
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

pm = propagationModel('freespace');
% txSite = site(wlanNodes(1).Position);
% rxSite = site(wlanNodes(2).Position);
txSite = txsite('Name', 'Transmitter1', ...
                'AntennaPosition', wlanNodes(1).Position');
rxSite = rxsite('Name', 'Transmitter2', ...
                'AntennaPosition', wlanNodes(1).Position');

% Calculate path loss
pl = pathloss(pm, rxSite, txSite);


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