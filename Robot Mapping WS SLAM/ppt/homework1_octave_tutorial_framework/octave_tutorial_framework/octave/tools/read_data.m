function data = read_data(filename)
    % Reads the odometry and sensor readings from a file.
    %
    % filename: path to the file to parse
    % data: structure containing the parsed information
    %
    % The data is returned in a structure where the u_t and z_t are stored
    % within a single entry. A z_t can contain observations of multiple
    % landmarks.
    %
    % Usage:
    % - access the readings for timestep i:
    %   data.timestep(i)
    %   this returns a structure containing the odometry reading and all
    %   landmark obsevations, which can be accessed as follows
    % - odometry reading at timestep i:
    %   data.timestep(i).odometry
    % - senor reading at timestep i:
    %   data.timestep(i).sensor
    %
    % Odometry readings have the following fields:
    % - r1 : rotation 1
    % - t  : translation
    % - r2 : rotation 2
    % which correspond to the identically labeled variables in the motion
    % mode.
    %
    % Sensor readings can again be indexed and each of the entris has the
    % following fields:
    % - id      : id of the observed landmark
    % - range   : measured range to the landmark
    % - bearing : measured angle to the landmark (you can ignore this)
    %
    % Examples:
    % - Translational component of the odometry reading at timestep 10
    %   data.timestep(10).odometry.t
    % - Measured range to the second landmark observed at timestep 4
    %   data.timestep(4).sensor(2).range
    input = fopen(filename);

    data = struct;
    data.timestep.sensor = struct;
    first = 1;

    odom = struct;
    sensor = struct;

    while(!feof(input))
        line = fgetl(input);
        arr = strsplit(line, ' ');
        type = deblank(arr{1});

        if(strcmp(type, 'ODOMETRY') == 1)
            if(first == 0)
                data.timestep(end+1).odometry = odom;
                data.timestep(end).sensor = sensor(2:end);
                odom = struct;
                sensor = struct;
            endif
            first = 0;
            odom.r1 = str2double(arr{2});
            odom.t  = str2double(arr{3});
            odom.r2 = str2double(arr{4});
        elseif(strcmp(type, 'SENSOR') == 1)
            reading = struct;
            reading.id      = str2double(arr{2});
            reading.range   = str2double(arr{3});
            reading.bearing = str2double(arr{4});
            sensor(end+1) = reading;
        endif
    endwhile

    data.timestep = data.timestep(2:end);

    fclose(input);
end
