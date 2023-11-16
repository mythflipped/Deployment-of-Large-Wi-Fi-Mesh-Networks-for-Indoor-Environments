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

% Create a cell array to represent the building structure
building = cell(length(roomsPerFloor), 1);

% Room specifications for each floor
roomSpecs = [
    % First floor
    0, 10, 0, 5, 3, 3;     % Room 1
    0, 10, 5, 10, 3, 3;    % Room 2
    10, 20, 0, 10, 3, 3;   % Room 3
    20, 30, 0, 10, 3, 3;   % Room 4
    
    % Second floor
    0, 10, 0, 10, 6, 6;    % Room 5
    10, 20, 0, 10, 6, 6;   % Room 6
    20, 30, 0, 10, 6, 6;   % Room 7
    
    % Third floor
    0, 10, 0, 5, 9, 9;     % Room 8
    0, 10, 5, 10, 9, 9;    % Room 9
    10, 20, 0, 5, 9, 9;    % Room 10
    10, 20, 5, 10, 9, 9;   % Room 11
    20, 30, 0, 10, 9, 9;   % Room 12
];

% Populate each floor with the specified number of rooms and dimensions
index = 1;
for floor = 1:length(roomsPerFloor)
    building{floor} = cell(1, roomsPerFloor(floor));
    
    for room = 1:roomsPerFloor(floor)
        % Create a room object with floor, room number, size, and location
        building{floor}{room} = struct(...
            'floor', floor, ...
            'roomNumber', room, ...
            'xRange', roomSpecs(index, 1:2), ...
            'yRange', roomSpecs(index, 3:4), ...
            'zRange', roomSpecs(index, 5:6), ...
            'height', floorHeight);
        
        % Move to the next set of room information
        index = index + 1;
    end
end

% Create a 3D figure for visualization
figure;

% Plot each room on each floor
for floor = 1:length(roomsPerFloor)
    for room = 1:roomsPerFloor(floor)
        plot3([building{floor}{room}.xRange(1), building{floor}{room}.xRange(2), building{floor}{room}.xRange(2), building{floor}{room}.xRange(1), building{floor}{room}.xRange(1)], ...
              [building{floor}{room}.yRange(1), building{floor}{room}.yRange(1), building{floor}{room}.yRange(2), building{floor}{room}.yRange(2), building{floor}{room}.yRange(1)], ...
              [building{floor}{room}.zRange(1), building{floor}{room}.zRange(1), building{floor}{room}.zRange(2), building{floor}{room}.zRange(2), building{floor}{room}.zRange(1)], 'b-', 'LineWidth', 1);
        hold on;
    end
end

% Set axis labels and title
xlabel('X-axis (m)');
ylabel('Y-axis (m)');
zlabel('Z-axis (m)');
title('3D Building Layout');

% Display room numbers
for floor = 1:length(roomsPerFloor)
    for room = 1:roomsPerFloor(floor)
        text((building{floor}{room}.xRange(1) + building{floor}{room}.xRange(2)) / 2, ...
            (building{floor}{room}.yRange(1) + building{floor}{room}.yRange(2)) / 2, ...
            (building{floor}{room}.zRange(1) + building{floor}{room}.zRange(2)) / 2, ...
            ['Room ', num2str(room)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b');
    end
end

% Display the floor layout
disp('Building Layout:');
for floor = 1:length(roomsPerFloor)
    disp(['Floor ', num2str(floor), ':']);
    for room = 1:roomsPerFloor(floor)
        disp(['Room ', num2str(room), ': x range [', num2str(building{floor}{room}.xRange), '], y range [', num2str(building{floor}{room}.yRange), '], z range [', num2str(building{floor}{room}.zRange), '], height [', num2str(floorHeight), ']']);
    end
    disp(' ');  % Add an empty line for better readability
end
