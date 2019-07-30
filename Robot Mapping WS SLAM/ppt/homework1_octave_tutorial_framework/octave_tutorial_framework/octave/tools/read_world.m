function landmarks = read_world(filename)
    % Reads the world definition and returns a structure of landmarks.
    %
    % filename: path of the file to load
    % landmarks: structure containing the parsed information
    %
    % Each landmark contains the following information:
    % - id : id of the landmark
    % - x  : x-coordinate
    % - y  : y-coordinate
    %
    % Examples:
    % - Obtain x-coordinate of the 5-th landmark
    %   landmarks(5).x
    input = fopen(filename);

    landmarks = struct;

    while(!feof(input))
        line = fgetl(input);
        data = strsplit(line, ' ');

        landmark = struct(
            "id", str2double(data{1}),
            "x" , str2double(data{2}),
            "y" , str2double(data{3})
        );
        landmarks(end+1) = landmark;
    endwhile

    landmarks = landmarks(2:end);

    fclose(input);
end
